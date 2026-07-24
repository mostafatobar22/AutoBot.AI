import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'obd_transport.dart';

class WifiElmTransport implements ObdTransport {
  Socket? _socket;
  final _rx = StringBuffer();
  final _rxController = StreamController<String>.broadcast();

  @override
  bool get isConnected => _socket != null;

  @override
  Future<void> connect({required String host, required int port}) async {
    _socket = await Socket.connect(host, port, timeout: const Duration(seconds: 5));
    _socket!.listen((data) {
      final s = utf8.decode(data, allowMalformed: true);
      _rx.write(s);
      _rxController.add(s);
    }, onDone: () {
      _socket = null;
    }, onError: (_) {
      _socket = null;
    });
  }

  @override
  Future<void> disconnect() async {
    try {
      await _socket?.close();
    } catch (_) {}
    _socket = null;
  }

  @override
  Future<String> sendRaw(String command) async {
    if (_socket == null) throw Exception("Not connected");

    _rx.clear();

    // ELM expects \r ending
    if (!command.endsWith("\r")) command = "$command\r";
    _socket!.add(utf8.encode(command));
    await _socket!.flush();

    // wait until prompt ">" appears or timeout
    final completer = Completer<String>();
    late StreamSubscription sub;

    Timer? t;
    t = Timer(const Duration(seconds: 2), () {
      sub.cancel();
      completer.complete(_rx.toString());
    });

    sub = _rxController.stream.listen((_) {
      final text = _rx.toString();
      if (text.contains(">")) {
        t?.cancel();
        sub.cancel();
        completer.complete(text);
      }
    });

    return completer.future;
  }
}