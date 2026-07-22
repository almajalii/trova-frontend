import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/identity-verification/logic/identity_verification_service.dart';
import 'package:trova/features/identity-verification/presentation/bloc/identity_verification_bloc.dart';
import 'package:trova/features/identity-verification/presentation/bloc/identity_verification_event.dart';
import 'package:trova/features/identity-verification/presentation/bloc/identity_verification_state.dart';
import 'package:trova/features/identity-verification/presentation/screens/sanad_verified_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/scan_id_screen.dart';
import 'package:trova/features/identity-verification/presentation/widget/identity_verification_layout.dart';
import 'package:trova/features/identity-verification/presentation/widget/sanad_modal.dart';

class IdentityVerificationScreen extends StatelessWidget {
  final String fullName;
  final ValueChanged<String>? onVerified;
  const IdentityVerificationScreen({super.key, required this.fullName, this.onVerified});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => IdentityVerificationBloc(identityVerificationService: sl<IdentityVerificationService>()),
        child: BlocConsumer<IdentityVerificationBloc, IdentityVerificationState>(
          listener: (context, state) {
            if (state is IdentityVerificationError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is SanadVerificationSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SanadVerifiedScreen(info: state.info, onVerified: onVerified),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is IdentityVerificationLoading;

            return Stack(
              children: [
                IdentityVerificationLayout(
                  onBack: () => Navigator.pop(context),
                  onSanadTap: () async {
                    final confirmed = await showSanadModal(context);
                    if (confirmed == true && context.mounted) {
                      context.read<IdentityVerificationBloc>().add(SanadVerificationRequested(fullName: fullName));
                    }
                  },
                  onScanTap: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ScanIdScreen(onVerified: onVerified))),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
