import 'package:bharatwork/core/constants/app_colors.dart';
import 'package:bharatwork/presentation/screens/home/home_page.dart';
import 'package:bharatwork/presentation/screens/register/personal_details_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart'; // <-- 1. IMPORT PINPUT

class SignupOtpPage extends StatefulWidget {
  const SignupOtpPage({super.key});

  @override
  State<SignupOtpPage> createState() => _SignupOtpPageState();
}

class _SignupOtpPageState extends State<SignupOtpPage> {
  // 2. Changed controller to be for OTP
  final TextEditingController _Signup_otpController = TextEditingController();
  final FocusNode _Signup_otpFocusNode = FocusNode();

  @override
  void dispose() {
    // 3. Dispose the new controller and focus node
    _Signup_otpController.dispose();
    _Signup_otpFocusNode.dispose();
    super.dispose();
  }

  // --- START OF ADDITION ---

  // Helper method to show a SnackBar
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

  // --- END OF ADDITION ---

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // Use double
    final width = MediaQuery.of(context).size.width; // Use double

    // 4. Define the themes for your Pinput boxes
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // Rounded corners
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.ButtonOrangeColor, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(240, 240, 240, 1), // Light grey bg
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.DefaultBgColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: height * 0.07,
            child: Text(
              "Sign-Up OTP Verification",
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
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Keep button stretched
                children: [
                  // 5. Added a text prompt for the OTP
                  Center(
                    child: Text(
                      "Enter your 4-Digit OTP",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const Gap(20), // Added more space
                  // 6. Replaced TextField with Pinput
                  Center(
                    // Center the OTP boxes
                    child: Pinput(
                      length: 4,
                      controller: _Signup_otpController,
                      focusNode: _Signup_otpFocusNode,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) {
                        print("OTP Completed: $pin");
                        // You can automatically trigger verification here
                        // Or just let the button handle it
                      },
                    ),
                  ),

                  const Gap(20), // Increased gap
                  ElevatedButton(
                    onPressed: () {
                      // --- START OF MODIFICATION ---

                      // 7. Updated button logic with SnackBar
                      final otp = _Signup_otpController.text;

                      if (otp.isEmpty) {
                        // Case 1: Empty
                        _showSnackBar(
                          context,
                          "Please enter the OTP",
                          isError: true,
                        );
                      } else if (otp.length < 4) {
                        // Case 2: Incomplete
                        _showSnackBar(
                          context,
                          "Please enter all 4 digits",
                          isError: true,
                        );
                      } else {
                        // Case 3: Complete (Ready to verify)
                        print("Verifying OTP: $otp");
                        context.push('/personal_details_page');
                        // TODO: Add your *actual* OTP verification logic here
                        // For example, call an API:
                        // bool isVerified = await authService.verifyOtp(otp);

                        // If verification is successful:
                        _showSnackBar(
                          context,
                          "OTP Verified Successfully!",
                          isError: false,
                        );
                        // And then navigate:
                        // e.g., Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));

                        // If verification fails from your backend:
                        // _showSnackBar(context, "Invalid OTP, please try again", isError: true);
                      }

                      // --- END OF MODIFICATION ---
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
                    child: Text(
                      "Verify & Continue",
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
