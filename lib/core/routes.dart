import 'package:flutter/material.dart';
import 'package:trova/features/browse-project/presentation/screen/browseproj_screen.dart';
import 'package:trova/features/log-in/presentation/screens/login_screen.dart';
import 'package:trova/features/mybids/presentation/screen/mybids_screen.dart';
import 'package:trova/features/onboarding/presentation/screens/onboard_screen.dart';
import 'package:trova/features/project-bid-detail/presentation/screen/projectdetailbid_screen.dart';
import 'package:trova/features/sign-up/presentation/screen/signup_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/forgot_password_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/identity_verification_screen.dart';
// NEW — scoring / guarantees feature screens
import 'package:trova/features/home-dashboard/presentation/screens/home_dashboard_screen.dart';
import 'package:trova/features/bank-connection/presentation/screens/connect_bank_account_screen.dart';
import 'package:trova/features/post-project/presentation/screens/post_a_project_screen.dart';
import 'package:trova/features/my-projects/presentation/screens/my_projects_screen.dart';
import 'package:trova/features/company-profile/presentation/screens/company_profile_screen.dart';
import 'package:trova/features/account-status/presentation/screens/account_pending_screen.dart';
import 'package:trova/features/account-status/presentation/screens/account_rejected_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String identityVerification = '/identity-verification';
  static const String homeDashboard = '/home';
  static const String connectBank = '/connect-bank';
  static const String postProject = '/post-project';
  static const String myProjects = '/my-projects'; // NEW
  static const String browseProjects = '/browse-projects'; 
  static const String projectDetail = '/project-detail'; // NEW
  static const String myBids = '/my-bids'; // NEW
  static const String companyProfile = '/company-profile'; // NEW
  static const String accountPending = '/account-pending'; // NEW — account approvalStatus == pending
  static const String accountRejected = '/account-rejected'; // NEW — account approvalStatus == rejected

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
         final args = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => IdentityVerificationScreen(fullName:args));
      case homeDashboard:
        return MaterialPageRoute(builder: (_) => const HomeDashboardScreen());
      case connectBank:
        return MaterialPageRoute(builder: (_) => const ConnectBankAccountScreen());
      case postProject:
        return MaterialPageRoute(builder: (_) => const PostAProjectScreen());
      case myProjects:
        return MaterialPageRoute(builder: (_) => const MyProjectsScreen());
        case browseProjects:
  return MaterialPageRoute(builder: (_) => const BrowseProjectsScreen());
      case projectDetail:
        final projectId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: projectId));
      case myBids:
        return MaterialPageRoute(builder: (_) => const MyBidsScreen());
      case companyProfile:
        return MaterialPageRoute(builder: (_) => const CompanyProfileScreen());
      case accountPending:
        return MaterialPageRoute(builder: (_) => const AccountPendingScreen());
      case accountRejected:
        final rejectionReason = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => AccountRejectedScreen(rejectionReason: rejectionReason));
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(body: Center(child: Text('404 - Route not found'))),
        );
    }
  }
}