import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/core/constants.dart';
// import 'package:leafcare/data/repositories/auth_repository.dart';
import 'package:leafcare/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _navigateToSceen();
  }

  void _navigateToSceen() async {
    await Future.delayed(Duration(seconds: 3));
      if (!mounted) return; // ✅ Prevent navigation if the widget is disposed

  final user = Supabase.instance.client.auth.currentUser;

  if (user != null) {
    Navigator.pushReplacementNamed(context, AppRoutes.home); // ✅ Go to Home if logged in
  } else {
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding); // ✅ Otherwise, go to Login
  }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Constants.lightgreen,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(width * 0.1),
              child: Image.asset(
                'assets/images/leafcare.jpg',
                width: width * 0.6,
                height: height * 0.3,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            Constants.appName,
            style: GoogleFonts.poppins(
              color: Constants.deepgreen,
              fontSize: width * 0.08,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
