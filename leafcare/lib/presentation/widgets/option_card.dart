 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildOptionCard({
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required IconData icon,
    VoidCallback? onTap, // Added onTap for navigation
  }) {
    return GestureDetector(
      onTap: onTap, // Handle tap event
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }