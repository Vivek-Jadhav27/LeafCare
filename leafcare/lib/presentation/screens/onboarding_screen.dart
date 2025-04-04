import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leafcare/presentation/widgets/onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/leafcare.jpg",
      "title": "Upload or Capture a Leaf Image",
      "description":
          "Take a photo or upload an image of the plant leaf you want to analyze."
    },
    {
      "image": "assets/images/leafcare.jpg",
      "title": "Get Instant Disease Detection",
      "description":
          "Our AI-powered system will analyze and detect any disease in the leaf."
    },
    {
      "image": "assets/images/leafcare.jpg",
      "title": "Know Prevention & Treatments",
      "description":
          "Get expert advice on how to treat the detected disease effectively."
    }
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) => OnboardingContent(
                image: onboardingData[index]["image"]!,
                title: onboardingData[index]["title"]!,
                description: onboardingData[index]["description"]!,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => buildDot(index),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: buildButtonRow(screenWidth),
          ),
          SizedBox(height: screenHeight * 0.03),
        ],
      ),
    );
  }

  Widget buildButtonRow(double screenWidth) {
    if (_currentPage == 0) {
      // First screen: Only "Next" button centered & full width
      return GestureDetector(
        onTap: () {
          _pageController.nextPage(
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        child: Container(
          margin: EdgeInsets.only(top: screenWidth * 0.1),
          height: screenWidth * 0.12,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Next",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    } else if (_currentPage == onboardingData.length - 1) {
      // Last screen: Only "Get Started" button centered & full width
      return GestureDetector(
        onTap: () {
          // Navigate to the next screen
          Navigator.pushNamed(context, '/login');
        },
        child: Container(
          margin: EdgeInsets.only(top: screenWidth * 0.1),
          height: screenWidth * 0.12,
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Get Started",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    } else {
      // Middle screen: "Back" and "Next" buttons in row, same size
      return Row(children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: Container(
              margin: EdgeInsets.only(top: screenWidth * 0.1),
              height: screenWidth * 0.12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green),
              ),
              child: Center(
                child: Text(
                  "Back",
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.05),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: Container(
              margin: EdgeInsets.only(top: screenWidth * 0.1),
              height: screenWidth * 0.12,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Next",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ]);
    }
  }

  Widget buildDot(int index) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 20 : 8,
      decoration: BoxDecoration(
        color:
            _currentPage == index ? Color.fromRGBO(63, 87, 60, 1) : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
