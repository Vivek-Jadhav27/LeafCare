class LeafModel {
  final String id;
  final String imageUrl;
  final String userId;
  final String uploadedAt;

  LeafModel({
    required this.id,
    required this.imageUrl,
    required this.userId,
    required this.uploadedAt,
  });

  factory LeafModel.fromJson(Map<String, dynamic> json) {
    return LeafModel(
      id: json['id'] ?? '',
      imageUrl: json['image_url'] ?? '',
      userId: json['user_id'] ?? '',
      uploadedAt: json['uploaded_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_url': imageUrl,
      'user_id': userId,
      'uploaded_at': uploadedAt,
    };
  }

  factory LeafModel.fromMap(Map<String, dynamic> map) {
    return LeafModel(
      id: map['id'] ?? '',
      imageUrl: map['image_url'] ?? '',
      userId: map['user_id'] ?? '',
      uploadedAt: map['uploaded_at'] ?? '',
    );
  }
}
