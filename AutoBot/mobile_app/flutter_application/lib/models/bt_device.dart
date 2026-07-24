class BtDevice {
  final String id; // MAC في classic / deviceId في BLE
  final String name;
  final bool isBle;

  BtDevice({required this.id, required this.name, required this.isBle});
}