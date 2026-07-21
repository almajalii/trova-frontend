import 'package:flutter/material.dart';
import 'package:trova/features/browse-project/presentation/screen/browseproj_screen.dart';
import 'package:trova/features/log-in/presentation/screens/login_screen.dart';
import 'package:trova/features/onboarding/presentation/screens/onboard_screen.dart';
import 'package:trova/features/sign-up/presentation/screen/signup_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/forgot_password_screen.dart';
// NEW — scoring / guarantees feature screens
import 'package:trova/features/home-dashboard/presentation/screens/home_dashboard_screen.dart';
import 'package:trova/features/bank-connection/presentation/screens/connect_bank_account_screen.dart';
import 'package:trova/features/post-project/presentation/screens/post_a_project_screen.dart';
import 'package:trova/features/my-projects/presentation/screens/my_projects_screen.dart';
import 'package:trova/features/company-profile/presentation/screens/company_profile_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  // NEW
  static const String homeDashboard = '/home';
  static const String connectBank = '/connect-bank';
  static const String postProject = '/post-project';
  static const String myProjects = '/my-projects'; // NEW
  static const String browseProjects = '/browse-projects';
  static const String companyProfile = '/company-profile'; // NEW

  // NOTE: verify-email and the identity-confirm screens require constructor
  // params (email, IdentityInfo, callbacks) that don't fit this simple named-
  // route switch. Push those directly with MaterialPageRoute from wherever
  // they're triggered (e.g. right after signup success), same way
  // check_email_screen.dart etc. already do internally.
  //
  // NEW — same applies to My Score, Bidders List, Compare Scores, Award +
  // Request Guarantee, and Guarantee Verified: they all take constructor
  // params (score/project/bidder data), so they're pushed directly via
  // MaterialPageRoute from Home Dashboard / Bidders List / Compare Scores
  // rather than being registered here. Only the three no-arg screens below
  // got named routes.

  // Returns null for anything unmatched — required so Flutter's implicit
  // '/' root-history entry (always generated ahead of `initialRoute` on
  // cold start, see Navigator.defaultGenerateInitialRoutes) gets silently
  // dropped instead of being inserted as a real page underneath onboarding.
  // Returning a real 404 page here made it resurface whenever the user
  // backed out past login/signup. Unmatched *explicit* pushNamed calls are
  // handled by MaterialApp.onUnknownRoute instead.
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      // NEW
      case homeDashboard:
        return MaterialPageRoute(builder: (_) => const HomeDashboardScreen());
      case connectBank:
        return MaterialPageRoute(builder: (_) => const ConnectBankAccountScreen());
      case postProject:
        return MaterialPageRoute(builder: (_) => const PostAProjectScreen());
      case myProjects:
        return MaterialPageRoute(builder: (_) => const MyProjectsScreen());
      case browseProjects: // NEW
        return MaterialPageRoute(builder: (_) => const BrowseProjectsScreen());
      case companyProfile: // NEW
        return MaterialPageRoute(builder: (_) => const CompanyProfileScreen());
      default:
        return null;
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    debugPrint('AppRoutes: no match for "${settings.name}" (args: ${settings.arguments})');
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('404 - Route not found: ${settings.name}')),
      ),
    );
  }
}
