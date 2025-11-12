// ADD THIS IMPORT at the top of your file
import 'package:bharatwork/features/auth/auth_contoller.dart';
import 'package:flutter/services.dart';

import 'package:bharatwork/core/constants/app_colors.dart';
import 'package:bharatwork/presentation/screens/auth/login/login_otp_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState(); // Fix: Changed return type to ConsumerState
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Good practice to dispose controllers
  final TextEditingController _PhoneNumberController = TextEditingController();

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
    _PhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // Use double
    final width = MediaQuery.of(context).size.width; // Use double
    final authState = ref.watch(authControllerProvider); // Access ref here
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final prev = previous; // Helper for readability

      // --- THIS IS THE FIX ---
      // Only show an error if we JUST finished loading and there's an error
      if (prev != null &&
          prev.isLoading &&
          !next.isLoading &&
          next.error != null) {
        _showSnackBar(context, next.error!, isError: true);
      }
      // --- END OF FIX ---

      // On success (code sent), navigate to OTP page
      // Your original success logic was correct, as verificationId is the trigger
      if (prev?.verificationId == null && next.verificationId != null) {
        _showSnackBar(context, 'OTP sent successfully!');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OtpPage()),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.DefaultBgColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: height * 0.07,
            child: Text(
              "Login Page",
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
          Positioned(
            bottom: height * 0.24,
            child: SizedBox(
              width: width * 0.83,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Colors.white,
                    child: TextField(
                      controller: _PhoneNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
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
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            // 1. Get the number from the text field for validation
                            final String phoneNumber = _PhoneNumberController
                                .text
                                .trim();

                            // 2. Run your validation logic
                            if (phoneNumber.isEmpty) {
                              _showSnackBar(
                                context,
                                'Please enter a phone number.',
                                isError: true,
                              );
                            } else if (phoneNumber.length != 10) {
                              _showSnackBar(
                                context,
                                'Please enter a 10-digit phone number.',
                                isError: true,
                              );
                            } else {
                              // 3. VALIDATION PASSED!
                              // Now, ignore the number you just checked and
                              // send the Firebase test number to bypass billing.
                              print(
                                "UI Validation Passed. Now sending Firebase test number...",
                              );

                              final String testPhoneNumber = '+19193386615';

                              // Call your AuthController to send the TEST OTP
                              ref
                                  .read(authControllerProvider.notifier)
                                  .sendOtp(testPhoneNumber);
                            }

                            // if (phoneNumber.isEmpty) {
                            //   _showSnackBar(
                            //     context,
                            //     'Please enter a phone number.',
                            //     isError: true,
                            //   );
                            // } else if (phoneNumber.length != 10) {
                            //   _showSnackBar(
                            //     context,
                            //     'Please enter a 10-digit phone number.',
                            //     isError: true,
                            //   );
                            // } else {
                            //   // This is the success case
                            //   // Add country code for Firebase
                            //   final String fullPhoneNumber =
                            //       '+91' + phoneNumber;

                            //   // Call your AuthController to send the OTP
                            //   ref
                            //       .read(authControllerProvider.notifier)
                            //       .sendOtp(fullPhoneNumber);
                            // }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ButtonOrangeColor,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: authState.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
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
