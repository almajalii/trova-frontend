import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/models/user_model.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/capability-score/logic/capability_score_service.dart';
import 'package:trova/features/company-details/logic/company_details_service.dart';
import 'package:trova/features/home-dashboard/logic/home_dashboard_model.dart';

class HomeDashboardService {
  final Dio dio;
  final CompanyDetailsService companyDetailsService;
  final CapabilityScoreService capabilityScoreService;
  HomeDashboardService({
    required this.dio,
    required this.companyDetailsService,
    required this.capabilityScoreService,
  });

  /// Eligible projects and recent activity still come from [_fetchBase]
  /// (mocked until /home/summary exists — see mock_mode.dart). Greeting,
  /// name, classification, and the score are always live: greeting is
  /// derived from the device clock, name comes from /auth/me,
  /// classification from the company-details record, and the score from
  /// /capability-score/me (the same endpoint My Score uses) — all real
  /// endpoints that already exist, so there's no reason to show stale demo
  /// values for them while the rest of the dashboard is still mocked.
  Future<HomeSummary> fetchSummary() async {
    // Run all four concurrently — they're independent, and chaining them
    // sequentially would make every dashboard load wait on the sum of the
    // network round-trips instead of just the slowest one.
    final results = await Future.wait([_fetchBase(), _fetchUserName(), _fetchClassification(), _fetchScore()]);
    final base = results[0] as HomeSummary;
    final userName = results[1] as String?;
    final classification = results[2] as ClassificationSummary?;
    final score = results[3] as HomeScoreSummary?;

    return HomeSummary(
      userName: userName ?? base.userName,
      greeting: _greetingForNow(),
      score: score ?? base.score,
      classification: classification ?? base.classification,
      eligibleProjects: base.eligibleProjects,
      recentActivity: base.recentActivity,
    );
  }

  Future<HomeSummary> _fetchBase() async {
    if (kUseMockHomeDashboard) {
      await Future.delayed(const Duration(milliseconds: 400));
      return HomeSummary.demo();
    }
    try {
      final response = await dio.get('/home/summary');
      return HomeSummary.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<String?> _fetchUserName() async {
    try {
      final response = await dio.get('/auth/me');
      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>).name;
    } on DioException {
      return null;
    }
  }

  Future<ClassificationSummary?> _fetchClassification() async {
    try {
      final record = await companyDetailsService.fetchMyCompanyDetails();
      return ClassificationSummary(code: record.classification.code, label: record.classification.label);
    } on ApiException {
      // Not submitted yet (404 — brand new user) or otherwise unavailable.
      return null;
    }
  }

  /// monthlyChangePoints has no live source yet (not part of
  /// /capability-score/me), so it's carried over from the mocked base
  /// summary regardless — only overall/tierLabel come from the real score.
  Future<HomeScoreSummary?> _fetchScore() async {
    try {
      final score = await capabilityScoreService.fetchMyScore();
      final demoMonthlyChange = HomeSummary.demo().score.monthlyChangePoints;
      return HomeScoreSummary(
        overall: score.overallScore,
        tierLabel: score.tierLabel,
        monthlyChangePoints: demoMonthlyChange,
      );
    } on ApiException {
      // No bank connected yet (404) or otherwise unavailable.
      return null;
    }
  }

  String _greetingForNow() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
