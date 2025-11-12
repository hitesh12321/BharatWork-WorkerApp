// import 'package:bharatwork/features/auth/auth_contoller.dart';
// import 'package:bharatwork/presentation/screens/auth/welcomepage.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pinput/pinput.dart';
// import 'package:bharatwork/core/constants/app_colors.dart';


// class OtpPage extends ConsumerStatefulWidget {
//   final String phoneNumber;
//   const OtpPage({super.key, required this.phoneNumber});

//   @override
//   ConsumerState<OtpPage> createState() => _OtpPageState();
// }

// class _OtpPageState extends ConsumerState<OtpPage> {
//   final TextEditingController _otpController = TextEditingController();
//   final FocusNode _otpFocusNode = FocusNode();

//   @override
//   void dispose() {
//     _otpController.dispose();
//     _otpFocusNode.dispose();
//     super.dispose();
//   }

//   void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
//         ),
//         backgroundColor: isError ? Colors.redAccent : Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;

//     final authState = ref.watch(authControllerProvider);

//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 60,
//       textStyle: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade400),
//       ),
//     );

//     final focusedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration!.copyWith(
//         border: Border.all(color: AppColors.ButtonOrangeColor, width: 2),
//       ),
//     );

//     final submittedPinTheme = defaultPinTheme.copyWith(
//       decoration: defaultPinTheme.decoration!.copyWith(
//         color: const Color.fromRGBO(240, 240, 240, 1),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: AppColors.DefaultBgColor,
//       body: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           Positioned(
//             top: height * 0.07,
//             child: Text(
//               "Login OTP Verification",
//               style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
//             ),
//           ),
//           Positioned(
//             top: height * 0.15,
//             child: Image.asset(
//               "assets/Login1.png",
//               height: height / 3.6,
//               width: width / 1.8,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "BharatWork",
//                   style: GoogleFonts.poppins(fontSize: width * 0.08, fontWeight: FontWeight.bold),
//                 ),
//                 Gap(width * 0.02),
//                 Text(
//                   "Connecting Workers with Opportunities",
//                   style: GoogleFonts.poppins(fontSize: width * 0.04, fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: height * 0.24,
//             child: SizedBox(
//               width: width * 0.83,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Center(
//                     child: Text(
//                       "Enter your 6-Digit OTP",
//                       style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
//                     ),
//                   ),
//                   const Gap(20),
//                   Center(
//                     child: Pinput(
//                       length: 6,
//                       controller: _otpController,
//                       focusNode: _otpFocusNode,
//                       defaultPinTheme: defaultPinTheme,
//                       focusedPinTheme: focusedPinTheme,
//                       submittedPinTheme: submittedPinTheme,
//                       showCursor: true,
//                       onCompleted: (pin) => print("OTP Completed: $pin"),
//                     ),
//                   ),
//                   const Gap(20),
//                   ElevatedButton(
//                     onPressed: authState.isLoading
//                         ? null
//                         : () async {
//                             final otp = _otpController.text.trim();

//                             if (otp.isEmpty || otp.length < 6) {
//                               _showSnackBar(context, "Please enter the full 6-digit OTP", isError: true);
//                               return;
//                             }

//                             _showSnackBar(context, "Verifying OTP...");

//                             await ref.read(authControllerProvider.notifier).verifyOtp(otp);
//                             final newState = ref.read(authControllerProvider);

//                             if (newState.error != null) {
//                               _showSnackBar(context, newState.error!, isError: true);
//                             } else {
//                               _showSnackBar(context, "OTP Verified Successfully!");
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => const Welcomepage()),
//                               );
//                             }
//                           },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.ButtonOrangeColor,
//                       foregroundColor: Colors.white,
//                       elevation: 5,
//                       padding: const EdgeInsets.symmetric(vertical: 17),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                     ),
//                     child: authState.isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : Text(
//                             "Verify & Continue",
//                             style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: height * 0.10,
//             child: Text(
//               "Powered by BharatWork",
//               style: GoogleFonts.poppins(fontSize: width * 0.04, fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }