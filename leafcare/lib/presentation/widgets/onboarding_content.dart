import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/core/constants.dart';

class OnboardingContent extends StatelessWidget {
  final String image, title, description;
  final double screenWidth, screenHeight;

  const OnboardingContent(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.screenWidth,
      required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: screenHeight * 0.3),
          SizedBox(height: screenHeight * 0.03),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.03,
              fontWeight: FontWeight.bold,
              color: Constants.deepgreen,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: screenHeight * 0.02,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
