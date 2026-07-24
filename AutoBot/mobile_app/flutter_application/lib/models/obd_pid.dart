class ObdPid {
  final String pid;
  final String name;
  final String unit;
  String value;

  ObdPid({
    required this.pid,
    required this.name,
    required this.unit,
    this.value = "--",
  });
}