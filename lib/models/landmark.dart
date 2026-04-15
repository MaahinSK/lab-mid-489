class Landmark {
  final int id;
  final String title;
  final double lat;
  final double lon;
  final String image;
  final double score;
  final int visitCount;
  final double avgDistance;
  final int isActive;

  Landmark({
    required this.id,
    required this.title,
    required this.lat,
    required this.lon,
    required this.image,
    required this.score,
    required this.visitCount,
    required this.avgDistance,
    required this.isActive,
  });

  bool get isDeleted => isActive == 0;

  factory Landmark.fromJson(Map<String, dynamic> json) {
    // Safe parsing functions
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed == null || parsed.isNaN || parsed.isInfinite) return 0.0;
        return parsed;
      }
      if (value is num) {
        if (value.isNaN || value.isInfinite) return 0.0;
        return value.toDouble();
      }
      return 0.0;
    }

    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is String) {
        final parsed = int.tryParse(value);
        return parsed ?? 0;
      }
      if (value is num) {
        if (value.isNaN || value.isInfinite) return 0;
        return value.toInt();
      }
      return 0;
    }

    // Parse lat/lon safely
    double lat = parseDouble(json['lat']);
    double lon = parseDouble(json['lon']);

    // Handle null lat/lon by setting to 0 (will be filtered out later)
    if (json['lat'] == null || json['lon'] == null) {
      lat = 0.0;
      lon = 0.0;
    }

    return Landmark(
      id: parseInt(json['id']),
      title: json['title']?.toString() ?? 'Unknown',
      lat: lat,
      lon: lon,
      image: json['image']?.toString() ?? '',
      score: parseDouble(json['score']),
      visitCount: parseInt(json['visit_count']),
      avgDistance: parseDouble(json['avg_distance']),
      isActive: json['is_active'] == null ? 1 : parseInt(json['is_active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'lat': lat,
      'lon': lon,
      'image': image,
      'score': score,
      'visit_count': visitCount,
      'avg_distance': avgDistance,
      'is_active': isActive,
    };
  }

  String get fullImageUrl {
    if (image.isEmpty) return '';
    if (image.startsWith('http')) {
      return image;
    }
    return 'https://labs.anontech.info/cse489/exm3/$image';
  }

  Landmark copyWith({
    int? id,
    String? title,
    double? lat,
    double? lon,
    String? image,
    double? score,
    int? visitCount,
    double? avgDistance,
    int? isActive,
  }) {
    return Landmark(
      id: id ?? this.id,
      title: title ?? this.title,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      image: image ?? this.image,
      score: score ?? this.score,
      visitCount: visitCount ?? this.visitCount,
      avgDistance: avgDistance ?? this.avgDistance,
      isActive: isActive ?? this.isActive,
    );
  }
}