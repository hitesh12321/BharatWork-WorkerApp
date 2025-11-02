import 'package:bharatwork/core/constants/app_colors.dart';
import 'package:bharatwork/presentation/screens/on_boarding/on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

// Added an enum to track the language choice clearly
enum Language { english, hindi }

class ChooseLanguage extends StatefulWidget {
  const ChooseLanguage({super.key});

  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  // Added state variable to hold the selected language
  Language? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // Use double
    final width = MediaQuery.of(context).size.width; // Use double

    return Scaffold(
      backgroundColor: AppColors.DefaultBgColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: height * 0.10,
            child: Image.asset(
              "assets/app_logo.png",
              height: height / 3.6,
              width: width / 1.8,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose Your Language",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(10),
                Text(
                  " अपनी भाषा चुनें ",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // --- ADDED WIDGETS START HERE ---
                const Gap(40), // Added space before the buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLanguageButton(
                      Language.english,
                      "English",
                      width,
                      height,
                    ),
                    const Gap(20),
                    _buildLanguageButton(
                      Language.hindi,
                      "हिंदी",
                      width,
                      height,
                    ),
                  ],
                ),
                // --- ADDED WIDGETS END HERE ---
              ],
            ),
          ),
          Positioned(
            bottom: height * 0.20,
            child: ElevatedButton(
              // Updated onPressed: button is disabled if no language is selected
              onPressed: selectedLanguage == null
                  ? null // Disables the button
                  : () {
                      // Handle submit logic here
                      print("Selected language: $selectedLanguage");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OnBoardingPage(),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ButtonOrangeColor,

                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.2,
                  vertical: height * 0.015,
                ),
              ),
              child: Text(
                "Submit",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.TextWhiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- ADDED HELPER METHOD ---
  /// Builds a language selection button.
  /// Shows as an ElevatedButton if selected, otherwise OutlinedButton.
  Widget _buildLanguageButton(
    Language lang,
    String text,
    double width,
    double height,
  ) {
    final bool isSelected = selectedLanguage == lang;

    // Use ElevatedButton for selected, OutlinedButton for unselected
    return isSelected
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(width * 0.40, height * 0.06),
              // Use your app's primary color
              backgroundColor: AppColors.ButtonOrangeColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              // Already selected, do nothing
            },
            child: Text(
              text,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              fixedSize: Size(width * 0.40, height * 0.06),
              // Use your app's primary color for the outline
              foregroundColor: Colors.amber,
              side: BorderSide(color: AppColors.ButtonOrangeColor),
            ),
            onPressed: () {
              // Set the state to update the UI
              setState(() {
                selectedLanguage = lang;
              });
            },
            child: Text(
              text,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          );
  }
}
