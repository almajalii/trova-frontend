import 'package:flutter/material.dart';
import 'package:trova/features/email-verification/presentation/screens/verify_email_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/forgot_password_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/check_email_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/set_new_password_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/password_reset_success_screen.dart';
import 'package:trova/features/identity-verification/logic/identity_info.dart';
import 'package:trova/features/identity-verification/presentation/screens/identity_verification_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/sanad_verified_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/scan_id_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/scan_verified_screen.dart';
// NEW — company details onboarding step
import 'package:trova/features/company-details/presentation/screens/company_details_screen.dart';
// NEW — scoring / guarantees feature screens
import 'package:trova/features/home-dashboard/presentation/screens/home_dashboard_screen.dart';
import 'package:trova/features/capability-score/presentation/screens/my_score_screen.dart';
import 'package:trova/features/bank-connection/presentation/screens/connect_bank_account_screen.dart';
import 'package:trova/features/post-project/presentation/screens/post_a_project_screen.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/bidders/presentation/screens/bidders_list_screen.dart';
import 'package:trova/features/bidders/presentation/screens/compare_scores_screen.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'package:trova/features/guarantees/presentation/screens/award_request_guarantee_screen.dart';
import 'package:trova/features/guarantees/presentation/screens/guarantee_verified_screen.dart';

const _dummyEmail = 'ahmad.khalil@email.com';
const _dummyIdentity = IdentityInfo(
  fullName: 'Ahmad Khalil Al-Rawi',
  nationalId: '9984512345',
);

// NEW — dummy data for the scoring/guarantees screens
final _dummyBidders = Bidder.demoList();
final _dummyGuarantee = Guarantee(
  id: 'TRV-GT-88213',
  amountJod: 23800,
  type: GuaranteeType.performance,
  issuingBank: 'Arab Bank',
  validUntil: DateTime(2027, 7, 10),
  status: 'ACTIVE',
);

class ScreensGallery extends StatelessWidget {
  const ScreensGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = <(String, WidgetBuilder)>[
      ('Verify Your Email', (_) => const VerifyEmailScreen(email: _dummyEmail)),
      ('Forgot Password', (_) => const ForgotPasswordScreen()),
      ('Check Your Email (OTP)', (_) => const CheckEmailScreen(email: _dummyEmail)),
      ('Set New Password', (_) => const SetNewPasswordScreen(token: '123456')),
      ('Password Reset Success', (_) => const PasswordResetSuccessScreen()),
      ('Identity Verification (chooser)', (_) => const IdentityVerificationScreen()),
      ('Sanad Verified', (_) => const SanadVerifiedScreen(info: _dummyIdentity)),
      ('Scan National ID', (_) => const ScanIdScreen()),
      ('Scan Verified', (_) => const ScanVerifiedScreen(info: _dummyIdentity)),
      ('Company Details', (_) => const CompanyDetailsScreen()),
      // NEW — backend calls inside these will fail (no endpoints on
      // TrovaBackend yet); that's expected, you're just checking UI here.
      ('Home Dashboard', (_) => const HomeDashboardScreen()),
      ('My Score', (_) => const MyScoreScreen()),
      ('Connect Bank Account', (_) => const ConnectBankAccountScreen()),
      ('Post a Project', (_) => const PostAProjectScreen()),
      (
        'Bidders List',
        (_) => const BiddersListScreen(projectId: 'demo-project-id', projectTitle: 'Al-Noor Tower'),
      ),
      (
        'Compare Scores',
        (_) => CompareScoresScreen(
              projectId: 'demo-project-id',
              projectTitle: 'Al-Noor Tower',
              bidders: _dummyBidders.take(2).toList(),
            ),
      ),
      (
        'Award + Request Guarantee',
        (_) => AwardRequestGuaranteeScreen(
              projectId: 'demo-project-id',
              projectTitle: 'Al-Noor Tower',
              awardedBidder: _dummyBidders.first,
            ),
      ),
      ('Guarantee Verified', (_) => GuaranteeVerifiedScreen(guarantee: _dummyGuarantee)),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Screens gallery (dev only)')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: entries.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final (label, builder) = entries[index];
          return ListTile(
            title: Text(label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: builder)),
          );
        },
      ),
    );
  }
}
