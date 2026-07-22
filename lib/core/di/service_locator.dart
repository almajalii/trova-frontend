import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:trova/core/network/dio_client.dart';
import 'package:trova/core/services/biometric_auth_service.dart';
import 'package:trova/core/storage/token_storage.dart';
import 'package:trova/features/bid-detail/logic/bid_detail_service.dart';
import 'package:trova/features/browse-project/logic/browseproj_service.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_service.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_service.dart';
import 'package:trova/features/leave-review/logic/leave_review_service.dart';
import 'package:trova/features/log-in/logic/biometric_login_service.dart';
import 'package:trova/features/log-in/logic/login_service.dart';
import 'package:trova/features/project-detail/logic/project_detail_service.dart';
import 'package:trova/features/project-history/logic/project_history_service.dart';
import 'package:trova/features/repost-project/logic/repost_project_service.dart';
import 'package:trova/features/review-work/logic/review_work_service.dart';
import 'package:trova/features/sign-up/logic/signup_service.dart';
import 'package:trova/features/email-verification/logic/verify_email_service.dart';
import 'package:trova/features/forgot-password/logic/forgot_password_service.dart';
import 'package:trova/features/identity-verification/logic/identity_verification_service.dart';
// NEW — company details (onboarding step between identity verification and bank connection)
import 'package:trova/features/company-details/logic/company_details_service.dart';
// NEW — Company Profile screen (read-only view, opened from the bottom nav)
import 'package:trova/features/company-profile/logic/company_profile_service.dart';
import 'package:trova/features/company-profile/logic/company_reviews_service.dart';
// NEW — scoring / guarantees feature services
import 'package:trova/features/home-dashboard/logic/home_dashboard_service.dart';
import 'package:trova/features/capability-score/logic/capability_score_service.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_service.dart';
import 'package:trova/features/post-project/logic/post_project_service.dart';
import 'package:trova/features/bidders/logic/bidder_profile_service.dart';
import 'package:trova/features/bidders/logic/bidders_service.dart';
import 'package:trova/features/guarantees/logic/guarantee_service.dart';
import 'package:trova/features/my-projects/logic/my_projects_service.dart';
import 'package:trova/features/mybids/logic/mybid_service.dart';
import 'package:trova/features/bid-history/logic/bid_history_service.dart';
import 'package:trova/features/notifications/logic/notification_service.dart';

/// Global service locator. Call `setupLocator()` once in main() before
/// runApp(). Access anything registered here via `sl<Type>()`.
///
/// As new features are added (e.g. contractor scoring, guarantees, Open
/// Finance integration), register their services here too — same pattern.
final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core / infra — registered as lazy singletons so there's only ever
  // one instance shared across the whole app.
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
  sl.registerLazySingleton<Dio>(() => DioClient.create(sl<TokenStorage>()));

  // Feature services
  sl.registerLazySingleton<BiometricAuthService>(() => BiometricAuthService());
  sl.registerLazySingleton<LoginService>(() => LoginService(dio: sl<Dio>(), tokenStorage: sl<TokenStorage>()));
  sl.registerLazySingleton<BiometricLoginService>(
    () => BiometricLoginService(
      dio: sl<Dio>(),
      tokenStorage: sl<TokenStorage>(),
      biometricAuthService: sl<BiometricAuthService>(),
    ),
  );
  sl.registerLazySingleton<SignupService>(() => SignupService(dio: sl<Dio>(), tokenStorage: sl<TokenStorage>()));
  sl.registerLazySingleton<VerifyEmailService>(() => VerifyEmailService(dio: sl<Dio>()));
  sl.registerLazySingleton<ForgotPasswordService>(() => ForgotPasswordService(dio: sl<Dio>()));
  // Sanad stays mocked; saveVerification() is real — see
  // identity_verification_service.dart for details.
  sl.registerLazySingleton<IdentityVerificationService>(() => IdentityVerificationService(dio: sl<Dio>()));

  // NEW — company details, submitted right after identity verification
  sl.registerLazySingleton<CompanyDetailsService>(() => CompanyDetailsService(dio: sl<Dio>()));

  // NEW — Company Profile screen (read-only view, opened from the bottom nav)
  sl.registerLazySingleton<CompanyReviewsService>(() => CompanyReviewsService(dio: sl<Dio>()));

  // NEW — scoring / guarantees feature services (none of these endpoints
  // exist on TrovaBackend yet; wire them up when the .NET side is ready).
  sl.registerLazySingleton<CapabilityScoreService>(() => CapabilityScoreService(dio: sl<Dio>()));
  sl.registerLazySingleton<HomeDashboardService>(
    () => HomeDashboardService(
      dio: sl<Dio>(),
      companyDetailsService: sl<CompanyDetailsService>(),
      capabilityScoreService: sl<CapabilityScoreService>(),
    ),
  );
  sl.registerLazySingleton<CompanyProfileService>(
    () => CompanyProfileService(
      companyDetailsService: sl<CompanyDetailsService>(),
      capabilityScoreService: sl<CapabilityScoreService>(),
      companyReviewsService: sl<CompanyReviewsService>(),
    ),
  );
  sl.registerLazySingleton<BankConnectionService>(() => BankConnectionService(dio: sl<Dio>()));
  sl.registerLazySingleton<PostProjectService>(() => PostProjectService(dio: sl<Dio>()));
  sl.registerLazySingleton<BiddersService>(() => BiddersService(dio: sl<Dio>()));
  sl.registerLazySingleton<BidderProfileService>(() => BidderProfileService(dio: sl<Dio>()));
  sl.registerLazySingleton<GuaranteeService>(() => GuaranteeService(dio: sl<Dio>()));
  sl.registerLazySingleton<MyProjectsService>(() => MyProjectsService(dio: sl<Dio>()));
  sl.registerLazySingleton<ProjectHistoryService>(() => ProjectHistoryService(dio: sl<Dio>()));
  sl.registerLazySingleton<ProjectDetailService>(() => ProjectDetailService(dio: sl<Dio>()));
  sl.registerLazySingleton<GuaranteeReviewService>(() => GuaranteeReviewService(dio: sl<Dio>()));
  sl.registerLazySingleton<ReviewWorkService>(() => ReviewWorkService(dio: sl<Dio>()));
  sl.registerLazySingleton<RepostProjectService>(() => RepostProjectService(dio: sl<Dio>()));
  sl.registerLazySingleton<LeaveReviewService>(() => LeaveReviewService(dio: sl<Dio>()));
  sl.registerLazySingleton(() => ProjectsService(dio: sl<Dio>()));
  sl.registerLazySingleton<BidDetailService>(() => BidDetailService(dio: sl<Dio>()));
  sl.registerLazySingleton<ProjectBidDetailService>(() => ProjectBidDetailService(dio: sl<Dio>()));
  sl.registerLazySingleton<BidsService>(() => BidsService(dio: sl<Dio>()));
  sl.registerLazySingleton<BidHistoryService>(() => BidHistoryService(dio: sl<Dio>()));
  sl.registerLazySingleton<NotificationService>(() => NotificationService(dio: sl<Dio>()));
}
