import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/data/models/user_model.dart';
import 'package:leafcare/presentation/bloc/profile/profile_bloc.dart';
import 'package:leafcare/presentation/bloc/profile/profile_event.dart';
import 'package:leafcare/presentation/bloc/profile/profile_state.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadUserProfile()),
      child: const ProfileScreenBody(),
    );
  }
}

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {
  bool isDarkMode = false;

  /// ✅ **Pull-to-refresh function**
  Future<void> _refreshProfile(BuildContext context) async {
    context.read<ProfileBloc>().add(LoadUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileUpdating) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return RefreshIndicator(
              onRefresh: () => _refreshProfile(context), // ✅ Pull-to-refresh
              child: _buildProfileContent(context, user),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text("Unexpected error"));
          }
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    user.profileImage != null && user.profileImage!.isNotEmpty
                        ? NetworkImage(user.profileImage!)
                        : const AssetImage('assets/images/avatar.png')
                            as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    _showImagePicker(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.camera_alt,
                        size: 20, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: GoogleFonts.poppins(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            user.email,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          // Dark Mode Toggle
          _buildProfileOption(
            title: "Dark Mode",
            icon: LucideIcons.moon,
            trailing: Switch(
              value: isDarkMode,
              activeColor: Colors.green,
              onChanged: (value) {
                context.read<ProfileBloc>().add(ToggleDarkMode(value));
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ),
          _buildProfileOption(title: "About App", icon: LucideIcons.info),
          _buildProfileOption(
              title: "Help & Support", icon: LucideIcons.helpCircle),

          _buildProfileOption(
              title: "Privacy Policy", icon: LucideIcons.shieldCheck),

          const SizedBox(height: 30),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(LucideIcons.logOut, color: Colors.white),
              label: Text(
                "Logout",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onPressed: () {
                context.read<ProfileBloc>().add(LogoutUser(context));
              },
            ),
          ),
          const Spacer(),
          // App Version
          const Text("Version 1.0.1", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
      {required String title, required IconData icon, Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
      ),
      trailing: trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
      onTap: () {},
    );
  }

  void _showImagePicker(BuildContext context) {
    context.read<ProfileBloc>().add(UpdateProfilePicture(ImageSource.gallery));
  }
}
