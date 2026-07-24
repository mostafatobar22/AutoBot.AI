import 'dart:async';
import 'obd_transport.dart';

class ElmObdClient {
  final ObdTransport transport;
  Timer? _timer;

  ElmObdClient(this.transport);

  Future<void> initElm() async {
    // إعدادات أساسية للـ ELM (اختياري بس مفيد)
    await transport.sendRaw("ATZ");
    await transport.sendRaw("ATE0"); // echo off
    await transport.sendRaw("ATL0"); // linefeeds off
    await transport.sendRaw("ATS0"); // spaces off
    await transport.sendRaw("ATH0"); // headers off
    await transport.sendRaw("ATSP0"); // auto protocol
  }

  // ---------- Helpers ----------
  String _clean(String raw) {
    // remove prompt + CR/LF
    var s = raw.replaceAll(">", "");
    s = s.replaceAll("\r", "\n");
    s = s.replaceAll("\n\n", "\n").trim();
    return s;
  }

  List<int> _extractHexBytes(String cleaned) {
    // supports: "410C1AF8" or "41 0C 1A F8" or multi lines
    final hex = cleaned
        .replaceAll(RegExp(r'[^0-9A-Fa-f]'), ' ')
        .trim()
        .split(RegExp(r'\s+'))
        .where((x) => x.isNotEmpty)
        .toList();

    final bytes = <int>[];
    for (final h in hex) {
      if (h.length == 0) continue;
      // if chunk like "410C1AF8" split into pairs
      if (h.length > 2 && h.length.isEven) {
        for (int i = 0; i < h.length; i += 2) {
          bytes.add(int.parse(h.substring(i, i + 2), radix: 16));
        }
      } else if (h.length == 2) {
        bytes.add(int.parse(h, radix: 16));
      }
    }
    return bytes;
  }

  // ---------- Supported PIDs ----------
  Future<Set<int>> readSupportedPids() async {
    // PID support bitmasks: 0100,0120,0140,0160,0180,01A0
    final queries = [0x00, 0x20, 0x40, 0x60, 0x80, 0xA0];
    final supported = <int>{};

    for (final base in queries) {
      final cmd = "01${base.toRadixString(16).padLeft(2, '0').toUpperCase()}";
      final raw = await transport.sendRaw(cmd);
      final cleaned = _clean(raw);
      final bytes = _extractHexBytes(cleaned);

      // Expect: 41 <pid> <A> <B> <C> <D>
      // Find pattern 0x41 then pid then 4 bytes
      for (int i = 0; i + 5 < bytes.length; i++) {
        if (bytes[i] == 0x41 && bytes[i + 1] == base && (i + 5) < bytes.length) {
          final a = bytes[i + 2];
          final b = bytes[i + 3];
          final c = bytes[i + 4];
          final d = bytes[i + 5];
          final mask = (a << 24) | (b << 16) | (c << 8) | d;

          for (int bit = 0; bit < 32; bit++) {
            final isSet = (mask & (1 << (31 - bit))) != 0;
            if (isSet) {
              final pid = base + (bit + 1);
              supported.add(pid);
            }
          }
        }
      }
    }

    return supported;
  }

  // ---------- Read Live Snapshot ----------
  Future<Map<String, dynamic>> readAllLiveData({Set<int>? cachedPids}) async {
    final pids = cachedPids ?? await readSupportedPids();

    // اختار PIDs “مفيدة” بس عشان ما نعملش ضغط (ممكن توسّع بعدين)
    final preferred = <int>{
      0x0C, // RPM
      0x0D, // Speed
      0x05, // Coolant
      0x0F, // Intake Air Temp
      0x11, // Throttle
      0x2F, // Fuel Level
      0x42, // Control module voltage
      0x46, // Ambient air temp
    };

    final chosen = pids.intersection(preferred).toList()..sort();
    final result = <String, dynamic>{};

    for (final pid in chosen) {
      final cmd = "01${pid.toRadixString(16).padLeft(2, '0').toUpperCase()}";
      final raw = await transport.sendRaw(cmd);
      final cleaned = _clean(raw);

      // لو NO DATA/ERROR
      if (cleaned.toUpperCase().contains("NO DATA") || cleaned.toUpperCase().contains("ERROR")) {
        result["0x${pid.toRadixString(16).toUpperCase()}"] = null;
        continue;
      }

      result["0x${pid.toRadixString(16).toUpperCase()}"] = cleaned;
    }

    return result;
  }

  // ---------- Live Stream every second ----------
  void startLiveStream({
    required void Function(Map<String, dynamic> snapshot) onSnapshot,
    required void Function(Object e) onError,
    Duration period = const Duration(seconds: 1),
  }) async {
    final supported = await readSupportedPids();

    _timer?.cancel();
    _timer = Timer.periodic(period, (_) async {
      try {
        final snap = await readAllLiveData(cachedPids: supported);
        onSnapshot(snap);
      } catch (e) {
        onError(e);
      }
    });
  }

  void stopLiveStream() {
    _timer?.cancel();
    _timer = null;
  }

  // ---------- DTCs ----------
  Future<String> readDtcsRaw() async {
    final raw = await transport.sendRaw("03");
    return _clean(raw);
  }

  // ---------- VIN ----------
  Future<String> readVinRaw() async {
    final raw = await transport.sendRaw("0902");
    return _clean(raw);
  }
}