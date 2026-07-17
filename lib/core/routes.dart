import 'package:flutter/material.dart';
import 'package:trova/features/log-in/presentation/screens/login_screen.dart';
import 'package:trova/features/onboarding/presentation/screens/onboard_screen.dart';
import 'package:trova/features/sign-up/presentation/screen/signup_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/forgot_password_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/identity_verification_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String identityVerification = '/identity-verification';

  // NOTE: verify-email and the identity-confirm screens require constructor
  // params (email, IdentityInfo, callbacks) that don't fit this simple named-
  // route switch. Push those directly with MaterialPageRoute from wherever
  // they're triggered (e.g. right after signup success), same way
  // check_email_screen.dart etc. already do internally.

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case identityVerification:
        return MaterialPageRoute(builder: (_) => const IdentityVerificationScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('404 - Route not found'))),
        );
    }
  }
}
