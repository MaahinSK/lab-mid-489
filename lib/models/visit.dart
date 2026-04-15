class Visit {
  final int? id;
  final int landmarkId;
  final String landmarkName;
  final DateTime visitTime;
  final double distance;
  final double userLat;
  final double userLon;

  Visit({
    this.id,
    required this.landmarkId,
    required this.landmarkName,
    required this.visitTime,
    required this.distance,
    required this.userLat,
    required this.userLon,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] as int?,
      landmarkId: json['landmark_id'] as int? ?? 0,
      landmarkName: json['landmark_name'] as String? ?? '',
      visitTime: json['visit_time'] != null
          ? DateTime.parse(json['visit_time'] as String)
          : DateTime.now(),
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      userLat: (json['user_lat'] as num?)?.toDouble() ?? 0.0,
      userLon: (json['user_lon'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'landmark_id': landmarkId,
      'landmark_name': landmarkName,
      'visit_time': visitTime.toIso8601String(),
      'distance': distance,
      'user_lat': userLat,
      'user_lon': userLon,
    };

    // Only include id if it's not null
    if (id != null) {
      map['id'] = id!;
    }

    return map;
  }
}