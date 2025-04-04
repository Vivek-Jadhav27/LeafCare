class PredictionModel {
  final String id;
  final String userId;
  final String imageId;
  final String diseaseId;
  final double confidence;
  final String predictedAt;

  PredictionModel({
    required this.id,
    required this.userId,
    required this.imageId,
    required this.diseaseId,
    required this.confidence,
    required this.predictedAt,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      imageId: json['image_id'] ?? '',
      diseaseId: json['disease_id'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      predictedAt: json['predicted_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'image_id': imageId,
      'disease_id': diseaseId,
      'confidence': confidence,
      'predicted_at': predictedAt,
    };
  }

  factory PredictionModel.fromMap(Map<String, dynamic> map) {
    return PredictionModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      imageId: map['image_id'] ?? '',
      diseaseId: map['disease_id'] ?? '',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
      predictedAt: map['predicted_at'] ?? '',
    );
  }

  /// ✅ CopyWith Method for Updates
  PredictionModel copyWith({
    String? id,
    String? userId,
    String? imageId,
    String? diseaseId,
    double? confidence,
    String? predictedAt,
  }) {
    return PredictionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageId: imageId ?? this.imageId,
      diseaseId: diseaseId ?? this.diseaseId,
      confidence: confidence ?? this.confidence,
      predictedAt: predictedAt ?? this.predictedAt,
    );
  }
}
