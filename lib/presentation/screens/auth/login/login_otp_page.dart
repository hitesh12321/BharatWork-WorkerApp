import 'package:bharatwork/core/constants/app_colors.dart';
import 'package:bharatwork/presentation/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart'; // <-- 1. IMPORT PINPUT
import 'package:bharatwork/features/auth/auth_contoller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpPage extends ConsumerStatefulWidget {
  const OtpPage({super.key});

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  // 2. Changed controller to be for OTP
  final TextEditingController _Login_otpController = TextEditingController();
  final FocusNode _Login_otpFocusNode = FocusNode();

  @override
  void dispose() {
    // 3. Dispose the new controller and focus node
    _Login_otpController.dispose();
    _Login_otpFocusNode.dispose();
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
    final authState = ref.watch(authControllerProvider);

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

      // On success:
      // Your original success logic was already correct
      if (prev != null &&
          prev.isLoading &&
          !next.isLoading &&
          next.error == null &&
          prev.verificationId != null) {
        // Added one more check for safety
        _showSnackBar(context, "OTP Verified Successfully!", isError: false);
        // Navigate to Home and remove all previous screens
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false, // This removes the login stack
        );
      }
    });

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
              "Login OTP Verification",
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
                      // --- MODIFIED TEXT ---
                      "Enter your 6-Digit OTP",
                      // --- END OF MODIFICATION ---
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
                    child: Pinput(
                      // --- CRITICAL CHANGE ---
                      length: 6, // Firebase sends 6-digit codes
                      // --- END OF CHANGE ---
                      controller: _Login_otpController,
                      focusNode: _Login_otpFocusNode,
                      // ... rest of Pinput ...
                    ),
                  ),

                  const Gap(20), // Increased gap
                  ElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            // Disable when loading
                            final otp = _Login_otpController.text;

                            if (otp.isEmpty) {
                              _showSnackBar(
                                context,
                                "Please enter the OTP",
                                isError: true,
                              );
                            } else if (otp.length < 6) {
                              // Check for 6 digits
                              _showSnackBar(
                                context,
                                "Please enter all 6 digits",
                                isError: true,
                              );
                            } else {
                              // Call your AuthController to verify the OTP
                              ref
                                  .read(authControllerProvider.notifier)
                                  .verifyOtp(otp);
                            }
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
