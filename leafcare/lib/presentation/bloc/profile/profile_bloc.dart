  import 'dart:io';

  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:leafcare/data/repositories/auth_repository.dart';
  import 'package:leafcare/data/repositories/storage_repository.dart';
  import 'package:leafcare/presentation/bloc/profile/profile_event.dart';
  import 'package:leafcare/presentation/bloc/profile/profile_state.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
    final AuthRepository _authRepository = AuthRepository();
    final StorageRepository _storageRepository = StorageRepository();

    ProfileBloc() : super(ProfileInitial()) {
      on<LoadUserProfile>((event, emit) async {
        emit(ProfileLoading());
        try {
          final user = await _authRepository.getCurrentUser();
          if (user != null) {
            emit(ProfileLoaded(user));
          } else {
            emit(ProfileError("User not found"));
          }
        } catch (e) {
          emit(ProfileError("Failed to load user"));
        }
      });

      on<UpdateProfilePicture>((event, emit) async {
        if (state is ProfileLoaded) {
          final currentUser = (state as ProfileLoaded).user;

          try {
            emit(ProfileUpdating()); // Show loading indicator

            final image = await ImagePicker().pickImage(source: event.source);
            if (image == null) {
              emit(ProfileLoaded(currentUser)); // Reset state if canceled
              return;
            }

            // Upload new profile image
            final imageUrl = await _storageRepository.updateProfileImage(
                currentUser.id, File(image.path));

            if (imageUrl != null) {
              // Update in Supabase
              await _authRepository.updateUserProfilePicture(
                  currentUser.id, imageUrl);

              // ✅ Reload user data from Supabase instead of using copyWith
              final updatedUser = await _authRepository.getCurrentUser();
              emit(ProfileLoading());
              if (updatedUser != null) {
                
                emit(ProfileLoaded(updatedUser)); // ✅ Fully updated user data
              } else {
                emit(ProfileError("Failed to refresh user data."));
              }
            } else {
              emit(ProfileError("Failed to upload profile image"));
            }
          } catch (e) {
            emit(ProfileError("Error updating profile picture: $e"));
          }
        }
      });

      on<ToggleDarkMode>((event, emit) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isDarkMode', event.isDarkMode);
        emit(ProfileDarkModeChanged(event.isDarkMode));
      });

      on<LogoutUser>((event, emit) async {
        await _authRepository.signOut(event.context);
        emit(ProfileLoggedOut());
      });
    }

  
  }
