

class Spot {
  final String title;
  final String monitorUrl;
  final int canGo;

  Spot({
    required this.title,
    required this.monitorUrl,
    required this.canGo,
  });

  factory Spot.fromJson(Map<String, dynamic> json) {
    return Spot(
      title: json['景點'] ?? '',
      monitorUrl: json['及時影像'] ?? '',
      canGo: json['canGo'] ?? 0,
    );
  }
}

