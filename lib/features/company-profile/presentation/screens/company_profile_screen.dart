import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/success_badge.dart';
import 'package:trova/features/company-details/presentation/screens/company_details_screen.dart';
import 'package:trova/features/company-profile/logic/company_profile_service.dart';
import 'package:trova/features/company-profile/presentation/bloc/company_profile_bloc.dart';
import 'package:trova/features/company-profile/presentation/bloc/company_profile_event.dart';
import 'package:trova/features/company-profile/presentation/bloc/company_profile_state.dart';
import 'package:trova/features/company-profile/presentation/widget/company_profile_layout.dart';
import 'package:trova/features/settings/presentation/screens/settings_screen.dart';

class CompanyProfileScreen extends StatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  State<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<CompanyProfileScreen> {
  late final CompanyProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CompanyProfileBloc(companyProfileService: sl<CompanyProfileService>());
    _bloc.add(const CompanyProfileRequested());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _openEdit() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CompanyDetailsScreen()));
    // Company Details may have changed — refresh so Edit's changes show up
    // immediately instead of leaving stale data on screen.
    if (mounted) _bloc.add(const CompanyProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: _bloc,
        child: BlocBuilder<CompanyProfileBloc, CompanyProfileState>(
          builder: (context, state) {
            if (state is CompanyProfileInitial || state is CompanyProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CompanyProfileNotFound) {
              return _NotFoundView(onCompleteProfile: _openEdit);
            }
            if (state is CompanyProfileError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => _bloc.add(const CompanyProfileRequested()),
              );
            }
            final profile = (state as CompanyProfileLoaded).profile;
            return CompanyProfileLayout(
              profile: profile,
              onEdit: _openEdit,
              onSettings: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
            );
          },
        ),
      ),
      bottomNavigationBar: const TrovaBottomNav(activeIndex: 3),
    );
  }
}

class _NotFoundView extends StatelessWidget {
  final VoidCallback onCompleteProfile;
  const _NotFoundView({required this.onCompleteProfile});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                text: "You haven't completed your company profile yet.",
                textSize: 15,
                fontWeight: FontWeight.w600,
                textColor: colors.onSurface,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              AppText(
                text: 'Fill in your company details to see your profile here.',
                textSize: 13,
                textColor: colors.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Button(
                text: 'Complete Company Profile',
                textColor: Colors.white,
                borderRadius: 10,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                elevation: 0,
                buttonWidth: 240,
                buttonHeight: 46,
                onPressed: onCompleteProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(text: message, textSize: 14, textColor: colors.onSurface, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Button(
                text: 'Retry',
                textColor: Colors.white,
                borderRadius: 10,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                elevation: 0,
                buttonWidth: 160,
                buttonHeight: 44,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
