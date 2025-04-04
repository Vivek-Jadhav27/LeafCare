class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage; // Optional profile image URL

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
  });

   UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  // Convert from Supabase response (Map) to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profileImage: map['profile_image'],
    );
  }

  // Convert UserModel to a Map (for inserting into Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image': profileImage,
    };
  }
}
