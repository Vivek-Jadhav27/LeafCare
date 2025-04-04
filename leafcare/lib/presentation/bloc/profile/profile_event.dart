import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {}

class UpdateProfilePicture extends ProfileEvent {
  final ImageSource source;
  UpdateProfilePicture(this.source);
}

class ToggleDarkMode extends ProfileEvent {
  final bool isDarkMode;
  ToggleDarkMode(this.isDarkMode);
}

class LogoutUser extends ProfileEvent {
  final BuildContext context;
  LogoutUser(this.context);
}