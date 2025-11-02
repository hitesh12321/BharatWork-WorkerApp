import 'package:bharatwork/core/constants/app_colors.dart';
import 'package:bharatwork/models/onboard.dart';
import 'package:bharatwork/presentation/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

// Assume you have a login or home page to go to
// import 'package:bharatwork/presentation/screens/auth/login_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentindex = 0;
  // Added a PageController
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- Helper method to navigate to the next page ---
  void _navigateToNextScreen() {
    // Use pushReplacement to prevent user from going back to onboarding
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        // Replace this with your actual Login or Home Page
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // Use double
    final width = MediaQuery.of(context).size.width; // Use double
    return Scaffold(
      backgroundColor: AppColors.DefaultBgColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView.builder(
            controller: _pageController, // Added controller
            onPageChanged: (value) {
              setState(() {
                currentindex = value;
              });
            },
            itemCount: onboard.length,
            itemBuilder: (context, index) => Stack(
              children: [
                Positioned(
                  top: height * 0.15,
                  left: 0,
                  right: 0,
                  child: FadeInUp(
                    delay: Duration(milliseconds: 700),
                    child: Image.asset(
                      onboard[index].imagePath,
                      height: height / 3,
                      width: width / 1.5,
                      //fit: BoxFit.fill,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.0, 0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: FadeInDown(
                      delay: Duration(milliseconds: 700),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            onboard[index].text1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              color: AppColors.TextBlackColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap(15),
                          Text(
                            onboard[index].text2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              color: AppColors.TextBlackColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // --- MODIFIED Positioned widget for indicators/start button ---
          Positioned(
            bottom: height * 0.1, // Adjusted position slightly
            left: 0,
            right: 0,
            // Check if we are on the last page
            child: currentindex == onboard.length - 1
                ? _buildStartButton(context, width, height) // Show Start Button
                : _buildPageIndicators(width), // Show Dots and "Swipe"
          ),
          // --- MODIFIED Positioned widget for Skip button ---
          Positioned(
            right: width * 0.08,
            top: height * 0.06,
            // Wrap with Visibility to hide on last page
            child: Visibility(
              visible: currentindex != onboard.length - 1,
              child: TextButton(
                onPressed: () {
                  // Skip button navigates to next screen
                  _navigateToNextScreen();
                },
                child: Container(
                  // Use 'decoration' to add rounded corners
                  decoration: BoxDecoration(
                    color: AppColors.ButtonOrangeColor, // Move color inside
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ), // Adjust the radius as needed
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    "Skip",
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- NEW WIDGET METHOD for the Start Button ---
  Widget _buildStartButton(BuildContext context, double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: FadeInUp(
        delay: Duration(milliseconds: 500),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.ButtonOrangeColor,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, height * 0.06), // Full width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _navigateToNextScreen, // Navigate on press
          child: Text(
            "Get Started",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // --- EXTRACTED WIDGET METHOD for the Page Indicators ---
  Widget _buildPageIndicators(double width) {
    return FadeInUp(
      delay: Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dots
          ...List.generate(
            onboard.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: currentindex == index
                    ? AppColors.TextOrangeColor
                    : Colors.grey.withOpacity(0.5), // Fixed this color
                borderRadius: BorderRadius.circular(30),
              ),
              height: 15, // Adjusted size
              width: 15, // Adjusted size
              margin: EdgeInsets.only(right: 15), // Adjusted margin
            ),
          ),
          Gap(width * 0.1), // Gap from your commented code
          // Swipe Text
          Text(
            "Swipe >>",
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: AppColors.TextBlackColor.withOpacity(0.7),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
