import 'dart:convert';

class Disease {
  String id;
  final String name;
  final String category;
  final String description;
  final String severity;
  final List<String> recommendedTreatment;
  final List<String> preventionMethods;
  String imageUrl;

  Disease({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.severity,
    required this.recommendedTreatment,
    required this.preventionMethods,
    required this.imageUrl,
  });

  // Supabase
  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] ?? '',
      name: json['disease_name'] ?? 'Unknown Disease',
      category: json['category'] ?? 'Unknown',
      description: json['description'] ?? 'No description available.',
      severity: json['severity'] ?? 'Unknown',
      recommendedTreatment:
          List<String>.from(json['recommended_treatment'] ?? []),
      preventionMethods: List<String>.from(json['prevention_methods'] ?? []),
      imageUrl: json['image_url'] ?? 'assets/images/leafcare.jpg',
    );
  }

  ///

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disease_name': name,
      'category': category,
      'description': description,
      'severity': severity,
       'recommended_treatment': '{' + recommendedTreatment.map((e) => '"$e"').join(',') + '}', // ✅ Properly formatted PostgreSQL array
    'prevention_methods': '{' + preventionMethods.map((e) => '"$e"').join(',') + '}', // ✅ Properly formatted PostgreSQL array
 
      'image_url': imageUrl,
    };
  }

  /// ✅ Convert Disease object to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'disease_name': name,
      'category': category,
      'description': description,
      'severity': severity,
      'recommended_treatment':
          json.encode(recommendedTreatment), // Convert List to String
      'prevention_methods':
          json.encode(preventionMethods), // Convert List to String
      'image_url': imageUrl,
    };
  }

  /// ✅ Convert Map to Disease (For SQLite)
  factory Disease.fromMap(Map<String, dynamic> map) {
    return Disease(
      id: map['id'] ?? '',
      name: map['disease_name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      severity: map['severity'] ?? '',
      recommendedTreatment: (map['recommended_treatment'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preventionMethods: (map['prevention_methods'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imageUrl: map['image_url'] ?? '',
    );
  }

  /// ✅ CopyWith Method for Updates
  Disease copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? severity,
    List<String>? recommendedTreatment,
    List<String>? preventionMethods,
    String? imageUrl,
  }) {
    return Disease(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      recommendedTreatment: recommendedTreatment ?? this.recommendedTreatment,
      preventionMethods: preventionMethods ?? this.preventionMethods,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
