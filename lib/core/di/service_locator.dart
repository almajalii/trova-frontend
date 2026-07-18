import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:trova/core/network/dio_client.dart';
import 'package:trova/core/services/biometric_auth_service.dart';
import 'package:trova/core/storage/token_storage.dart';
import 'package:trova/features/log-in/logic/biometric_login_service.dart';
import 'package:trova/features/log-in/logic/login_service.dart';
import 'package:trova/features/sign-up/logic/signup_service.dart';
import 'package:trova/features/email-verification/logic/verify_email_service.dart';
import 'package:trova/features/forgot-password/logic/forgot_password_service.dart';
import 'package:trova/features/identity-verification/logic/identity_verification_service.dart';
// NEW — company details (onboarding step between identity verification and bank connection)
import 'package:trova/features/company-details/logic/company_details_service.dart';
// NEW — scoring / guarantees feature services
import 'package:trova/features/home-dashboard/logic/home_dashboard_service.dart';
import 'package:trova/features/capability-score/logic/capability_score_service.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_service.dart';
import 'package:trova/features/post-project/logic/post_project_service.dart';
import 'package:trova/features/bidders/logic/bidders_service.dart';
import 'package:trova/features/guarantees/logic/guarantee_service.dart';

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

  // NEW — scoring / guarantees feature services (none of these endpoints
  // exist on TrovaBackend yet; wire them up when the .NET side is ready).
  sl.registerLazySingleton<HomeDashboardService>(() => HomeDashboardService(dio: sl<Dio>()));
  sl.registerLazySingleton<CapabilityScoreService>(() => CapabilityScoreService(dio: sl<Dio>()));
  sl.registerLazySingleton<BankConnectionService>(() => BankConnectionService(dio: sl<Dio>()));
  sl.registerLazySingleton<PostProjectService>(() => PostProjectService(dio: sl<Dio>()));
  sl.registerLazySingleton<BiddersService>(() => BiddersService(dio: sl<Dio>()));
  sl.registerLazySingleton<GuaranteeService>(() => GuaranteeService(dio: sl<Dio>()));
}
