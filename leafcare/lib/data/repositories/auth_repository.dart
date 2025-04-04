import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:leafcare/apis_data.dart';
import 'package:leafcare/data/models/user_model.dart';
import 'package:leafcare/data/repositories/database_repository.dart';
import 'package:leafcare/data/repositories/storage_repository.dart';
import 'package:leafcare/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final StorageRepository _storageRepository = StorageRepository();

  ///     **Sign Up with Email & Password**
  Future<User?> signUp(String name, String email, String password) async {
    try {
      final response =
          await _supabase.auth.signUp(email: email, password: password);

      if (response.user != null) {
        // Save additional user data in the 'users' table
        final newUser = UserModel(
          id: response.user!.id,
          name: name,
          email: email,
        );
        await _databaseRepository.saveUserData(newUser);
        return response.user;
      }
    } catch (e) {
      print("    Sign Up Error: $e");
    }
    return null;
  }

  ///     **Login with Email & Password**
  Future<User?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      return response.user; // Returning the user object
    } catch (e) {
      print("    Login Error: $e");
      return null;
    }
  }

  ///     **Logout**
  Future<void> signOut(BuildContext context) async {
    try {
      await _supabase.auth.signOut();

      // Navigate to Splash Screen and remove all previous routes
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.splash, (route) => false);
    } catch (e) {
      if (kDebugMode) {
        print("    Logout Error: $e");
      }
    }
  }

  ///     **Check if User is Logged In**
  Future<UserModel?> getCurrentUser() async {
    final supabaseUser = _supabase.auth.currentUser;
    if (supabaseUser == null) return null; // No user is logged in

    final user = await _databaseRepository.getUserById(supabaseUser.id);
    return user ?? UserModel(id: supabaseUser.id, name: '', email: '');
  }

  ///     **Listen for Auth State Changes**
  Stream<AuthState> authStateChanges() {
    return _supabase.auth.onAuthStateChange;
  }

  ///     **Google Sign-In**
  Future<User?> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn =
          GoogleSignIn(serverClientId: ApisData.webClientId);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception("Google Sign-In canceled by user");
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw Exception("Google Sign-In failed: Missing tokens");
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        final userId = response.user!.id;

        // Check if user already exists in the database
        final existingUser = await _databaseRepository.getUserById(userId);
        print(" Existing user: ${existingUser?.toMap()}");

        if (existingUser == null) {
          print(" User does not exist, creating a new user...");

          // Upload profile image if available
          String? profileImageUrl;
          if (googleUser.photoUrl != null) {
            profileImageUrl = await _storageRepository.uploadProfileImage(
                userId, googleUser.photoUrl!);
          }

          // Save user to the database
          final newUser = UserModel(
            id: userId,
            name: googleUser.displayName ?? "User",
            email: googleUser.email,
            profileImage: profileImageUrl, // Store the URL
          );
          await _databaseRepository.saveUserData(newUser);
        }
      }

      return response.user;
    } catch (e) {
      if (kDebugMode) {
        print("    Google Sign-In Error: $e");
      }
      return null;
    }
  }

  Future<void> updateUserProfilePicture(String id, String imageUrl) async {
    try {
      await _databaseRepository.updateUserProfilePicture(id, imageUrl);
    } catch (e) {
      if (kDebugMode) {
        print("    Error updating user profile picture: $e");
      }
    }
  }
}
