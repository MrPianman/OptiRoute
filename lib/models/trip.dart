class Trip {
  final String id;
  final DateTime start;
  final DateTime end;
  final int expectedMinutes;
  final double distanceKm;
  final double fuelUsedL;
  final double profit;
  final int all;
  final int curr;

  const Trip({
    required this.id,
    required this.all,
    required this.curr,
    required this.start,
    required this.end,
    required this.expectedMinutes,
    required this.distanceKm,
    required this.fuelUsedL,
    required this.profit,
  });
}
