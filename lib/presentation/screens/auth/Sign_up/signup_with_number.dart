// ADD THIS IMPORT at the top of your file
import 'package:flutter/services.dart';

import 'package:bharatwork/core/constants/app_colors.dart';
import 'package:bharatwork/presentation/screens/auth/Sign_up/signup_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupWithNumber extends StatefulWidget {
  const SignupWithNumber({super.key});

  @override
  State<SignupWithNumber> createState() => _SignupWithNumberState();
}

class _SignupWithNumberState extends State<SignupWithNumber> {
  final TextEditingController _SignupPhoneNumberController =
      TextEditingController();

  // --- START OF NEW CODE ---
  // Your custom SnackBar function
  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(
      context,
    ).hideCurrentSnackBar(); // Hide any existing snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError
            ? Colors.redAccent
            : Colors.green, // Green for success, red for error
        behavior: SnackBarBehavior.floating, // Floats above bottom nav bar
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
  // --- END OF NEW CODE ---

  @override
  void dispose() {
    _SignupPhoneNumberController.dispose(); // Dispose the controller
    super.dispose();
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
          Positioned(
            top: height * 0.07,
            child: Text(
              "Sign-Up Page",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            top: height * 0.15,
            child: Image.asset(
              "assets/Login1.png",
              height: height / 3.6,
              width: width / 1.8,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "BharatWork",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(width * 0.02),
                Text(
                  "Connecting Workers with Opportunities",
                  style: GoogleFonts.poppins(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ... inside your Stack
          Positioned(
            bottom: height * 0.24,
            child: SizedBox(
              // 1. WRAP the Column in a SizedBox
              width: width * 0.83, // 2. SET the width to match your logo
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // 3. STRETCH children
                children: [
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _SignupPhoneNumberController,
                      // --- START OF EDITS ---
                      keyboardType: TextInputType.phone, // Show number pad
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Only allow numbers
                        LengthLimitingTextInputFormatter(
                          10,
                        ), // Limit to 10 digits
                      ],
                      // --- END OF EDITS ---
                      decoration: InputDecoration(
                        hintText: 'Enter Phone Number',
                        hintStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  ElevatedButton(
                    onPressed: () {
                      // --- START OF EDITS ---

                      // As requested, the validation logic is written but
                      // commented out. Remove the /* and */ to enable it.
                      /*
                      final String phoneNumber =
                          _SignupPhoneNumberController.text.trim();

                      if (phoneNumber.isEmpty) {
                        _showSnackBar(context, 'Please enter a phone number.',
                            isError: true);
                      } else if (phoneNumber.length != 10) {
                        _showSnackBar(
                            context, 'Please enter a 10-digit phone number.',
                            isError: true);
                      } else {
                        // This is the success case
                        // (Here you would add your OTP sending logic)

                        _showSnackBar(context, 'OTP sent successfully!');

                        // Navigate to OTP page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupOtpPage(),
                          ),
                        );
                      }
                      */

                      // Per your request, ONLY this part is active for now,
                      // so it will always run.
                      _showSnackBar(context, 'OTP sent successfully!');
                      context.push('/signup_otp_page');
                      // --- END OF EDITS ---
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ButtonOrangeColor,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(
                        vertical: 17,
                      ), // 5. REMOVE horizontal padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Get OTP",
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ... rest of your Stack
          /////////
          Positioned(
            bottom: height * 0.10,
            child: Text(
              "Powered by BharatWork",
              style: GoogleFonts.poppins(
                fontSize: width * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
