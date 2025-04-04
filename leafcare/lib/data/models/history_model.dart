class ScanHistory {
  final String id;
  final String predictedAt;
  final double confidence;
  final String imageUrl;
  final String diseaseName;
  final String category;
  final String description;
  final String severity;
  final List<String> recommendedTreatment;
  final List<String> preventionMethods;

  ScanHistory({
    required this.id,
    required this.predictedAt,
    required this.confidence,
    required this.imageUrl,
    required this.diseaseName,
    required this.category,
    required this.description,
    required this.severity,
    required this.recommendedTreatment,
    required this.preventionMethods,
  });

  /// ✅ **Convert JSON to ScanHistory Object**
  factory ScanHistory.fromJson(Map<String, dynamic> json) {
    return ScanHistory(
      id: json['id'],
      predictedAt: json['predictedAt'],
      confidence: double.parse(json['confidence'].toString()),
      imageUrl: json['imageUrl'],
      diseaseName: json['diseaseName'],
      category: json['category'],
      description: json['description'],
      severity: json['severity'],
      recommendedTreatment: (json['recommendedTreatment'] as List<dynamic>).map((e) => e.toString()).toList(),
      preventionMethods: (json['preventionMethods'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  /// ✅ **Convert ScanHistory Object to Map**
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'predictedAt': predictedAt,
      'confidence': confidence,
      'imageUrl': imageUrl,
      'diseaseName': diseaseName,
      'category': category,
      'description': description,
      'severity': severity,
      'recommendedTreatment': recommendedTreatment,
      'preventionMethods': preventionMethods,
    };
  }
}
