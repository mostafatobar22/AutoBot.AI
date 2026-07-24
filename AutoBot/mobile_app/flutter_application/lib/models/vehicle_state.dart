class VehicleState {
  final int speed;
  final int soc;
  final int batteryTemp;
  final int rangeKm;
  final String fault;

  const VehicleState({
    required this.speed,
    required this.soc,
    required this.batteryTemp,
    required this.rangeKm,
    required this.fault,
  });

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'soc': soc,
      'battery_temp': batteryTemp,
      'range_km': rangeKm,
      'fault': fault,
    };
  }

  String toPromptString() {
    return toJson().toString();
  }
}
