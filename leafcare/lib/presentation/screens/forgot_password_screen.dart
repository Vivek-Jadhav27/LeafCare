import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/core/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  Future<void> sendPasswordResetEmail() async {
    final String email = emailController.text.trim();
    if (email.isEmpty) {
      showSnackbar("Please enter your email");
      return;
    }
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      showSnackbar("Password reset link sent! Check your email.");
    } catch (e) {
      print(e.toString());
      showSnackbar("Error: ${e.toString()}");
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.poppins())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              Constants.logo, // Replace with actual asset path
              height: 120,
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              "Forgot Password",
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Instruction
            Text(
              "Enter your email address below, and we'll send you a link to reset your password.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Email Input Field
            TextField(
              controller: emailController,
              style: GoogleFonts.poppins(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Email address",
                labelStyle: GoogleFonts.poppins(color: Colors.black),
                hintText: "Enter your email",
                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Reset Password Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Match login button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: sendPasswordResetEmail,
                child: Text(
                  "Send Reset Link",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Back to Login
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                "Back to Login",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Match "Sign Up" text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
