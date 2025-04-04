import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/core/constants.dart';
import 'package:leafcare/routes/app_routes.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.pushNamed(context, AppRoutes.home);
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Illustration
                  Image.asset(Constants.logo, height: screenHeight * 0.20),

                  SizedBox(height: screenHeight * 0.03),

                  // Title
                  Text(
                    "Create an Account",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Full Name Field
                  TextField(
                    controller: nameController,
                    style:
                        GoogleFonts.poppins(color: Colors.black), // Black text
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      labelStyle: GoogleFonts.poppins(
                          color: Colors.black), // Label color
                      hintText: "Enter your name",
                      hintStyle:
                          GoogleFonts.poppins(color: Colors.grey), // Hint color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.green, width: 2), // Green border
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Email Field
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

                  SizedBox(height: screenHeight * 0.02),

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: GoogleFonts.poppins(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: GoogleFonts.poppins(color: Colors.black),
                      hintText: "Enter your password",
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

                  SizedBox(height: screenHeight * 0.02),

                  // Signup Button with Bloc
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  context.read<AuthBloc>().add(
                                        SignupRequested(
                                          nameController.text,
                                          emailController.text,
                                          passwordController.text,
                                        ),
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: state is AuthLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 18),
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // OR Text
                  Text("or", style: GoogleFonts.poppins(color: Colors.grey)),

                  SizedBox(height: screenHeight * 0.02),

                  // Google Sign-up Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(GoogleLoginRequested());
                      },
                      icon: Image.asset("assets/images/google.png", height: 24),
                      label: Text(
                        "Continue with Google",
                        style: GoogleFonts.poppins(
                            fontSize: 16, color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Already have an account? Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
