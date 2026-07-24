import 'dart:async';

class BluetoothHub {
  final List<String> _lastLines = [];
  final int maxLines;
  final _controller = StreamController<List<String>>.broadcast();

  BluetoothHub({this.maxLines = 30});

  Stream<List<String>> get snapshotStream => _controller.stream;

  List<String> get lastLines => List.unmodifiable(_lastLines);

  void addLine(String line) {
    final clean = line.trim();
    if (clean.isEmpty) return;

    _lastLines.add(clean);
    if (_lastLines.length > maxLines) {
      _lastLines.removeRange(0, _lastLines.length - maxLines);
    }
    _controller.add(lastLines);
  }

  void clear() {
    _lastLines.clear();
    _controller.add(lastLines);
  }

  void dispose() {
    _controller.close();
  }
}