class PendingVisit {
  final int id;
  final int landmarkId;
  final double userLat;
  final double userLon;
  final DateTime timestamp;

  PendingVisit({
    this.id = 0,
    required this.landmarkId,
    required this.userLat,
    required this.userLon,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'landmark_id': landmarkId,
      'user_lat': userLat,
      'user_lon': userLon,
    };
  }

  factory PendingVisit.fromMap(Map<String, dynamic> map) {
    return PendingVisit(
      id: map['id'],
      landmarkId: map['landmark_id'],
      userLat: map['user_lat'],
      userLon: map['user_lon'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'landmark_id': landmarkId,
      'user_lat': userLat,
      'user_lon': userLon,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}