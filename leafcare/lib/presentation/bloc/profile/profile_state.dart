import 'package:leafcare/data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileUpdating extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileDarkModeChanged extends ProfileState {
  final bool isDarkMode;
  ProfileDarkModeChanged(this.isDarkMode);
}

class ProfileLoggedOut extends ProfileState {}
