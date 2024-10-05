import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

import 'package:foxxi/providers/navigation_argument_data_provider.dart';
import 'package:foxxi/routing_constants.dart';
import 'package:foxxi/screens/forgot_password_resetscreen.dart';
import 'package:foxxi/screens/sign_up_screen.dart';
import 'package:foxxi/services/auth_service.dart';

class OTPScreen extends StatelessWidget {
  static const String routeName = otpScreenRoute;

  OTPScreen({
    Key? key,
  }) : super(key: key);
  final AuthService authService = AuthService();

  Future<bool> codeVerify(
      BuildContext context, String email, String verificationCode) async {
    bool isVerified = await authService.verifyCodeSent(
        context: context, email: email, code: verificationCode);
    return isVerified;
  }

  void navigateToSignUpScreen(BuildContext context) async {
    // Navigator.pushNamed(context, SignUpScreen.routeName);
    Navigator.pushNamed(context, SignUpScreen.routeName);
  }

  void navigateToResetPasswordScreen(BuildContext context) {
    Navigator.pushNamed(context, ForgotPasswordResetScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final miscProvider =
        Provider.of<ScreenNavigationArgumentProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Container(),
          ),
          const Text('Verification Code was Sent to your email'),
          const SizedBox(
            height: 24,
          ),
          OtpTextField(
            numberOfFields: 6,
            borderColor: const Color(0xFF512DA8),
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,

            onSubmit: (String verificationCode) async {
              final email = miscProvider.email;
              bool isVerified =
                  await codeVerify(context, email, verificationCode);
              log(isVerified.toString(), name: 'OTP verification');

              if (miscProvider.destination == forgotPasswordResetScreenRoute &&
                  isVerified) {
                navigateToResetPasswordScreen(context);
              } else if (miscProvider.destination == signUpScreenRoute &&
                  isVerified) {
                navigateToSignUpScreen(context);
              } else {
                log('Something went Wrong', name: 'Navigation from OTP ');
              }
            },
            // end onSubmit
          ),
          Flexible(flex: 2, child: Container())
        ],
      ),
    );
  }
}
