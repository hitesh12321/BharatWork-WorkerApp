// import 'package:bharatwork/features/auth/auth_contoller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:bharatwork/core/constants/app_colors.dart';
// import 'package:bharatwork/presentation/screens/auth/login/login_otp_page.dart';

// class LoginPage extends ConsumerStatefulWidget {
//   const LoginPage({super.key});

//   @override
//   ConsumerState<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends ConsumerState<LoginPage> {
//   final TextEditingController _phoneNumberController = TextEditingController();

//   @override
//   void dispose() {
//     _phoneNumberController.dispose();
//     super.dispose();
//   }

//   void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//           ),
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

//     return Scaffold(
//       backgroundColor: AppColors.DefaultBgColor,
//       body: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           Positioned(
//             top: height * 0.07,
//             child: Text(
//               "Login Page",
//               style: GoogleFonts.poppins(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w500,
//               ),
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
//                   style: GoogleFonts.poppins(
//                     fontSize: width * 0.08,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Gap(width * 0.02),
//                 Text(
//                   "Connecting Workers with Opportunities",
//                   style: GoogleFonts.poppins(
//                     fontSize: width * 0.04,
//                     fontWeight: FontWeight.w500,
//                   ),
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
//                   Container(
//                     color: Colors.white,
//                     child: TextField(
//                       controller: _phoneNumberController,
//                       keyboardType: TextInputType.phone,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                         LengthLimitingTextInputFormatter(10),
//                       ],
//                       decoration: InputDecoration(
//                         hintText: 'Enter Phone Number',
//                         hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
//                         contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const Gap(10),
//                   ElevatedButton(
//                     onPressed: authState.isLoading
//                         ? null
//                         : () async {
//                             final phoneNumber = _phoneNumberController.text.trim();

//                             if (phoneNumber.isEmpty || phoneNumber.length != 10) {
//                               _showSnackBar(context, 'Please enter a valid 10-digit phone number.', isError: true);
//                               return;
//                             }

//                             final fullPhoneNumber = '+91$phoneNumber';
//                             _showSnackBar(context, 'Sending OTP...$fullPhoneNumber');

//                             await ref.read(authControllerProvider.notifier).sendOtp('+19193386615');

//                             final newState = ref.read(authControllerProvider);
//                             if (newState.error != null) {
//                               _showSnackBar(context, newState.error!, isError: true);
//                             } else if (newState.verificationId != null) {
//                               _showSnackBar(context, 'OTP sent successfully!');
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => OtpPage(phoneNumber: fullPhoneNumber),
//                                 ),
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
//                             "Get OTP",
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
//               style: GoogleFonts.poppins(
//                 fontSize: width * 0.04,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }