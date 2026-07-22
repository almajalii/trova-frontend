import 'package:flutter/material.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/identity-verification/logic/identity_info.dart';
import 'package:trova/features/identity-verification/logic/identity_verification_service.dart';
import 'package:trova/features/identity-verification/presentation/widget/identity_confirm_layout.dart';

class SanadVerifiedScreen extends StatefulWidget {
  final IdentityInfo info;
  final ValueChanged<String>? onVerified;

  const SanadVerifiedScreen({super.key, required this.info, this.onVerified});

  @override
  State<SanadVerifiedScreen> createState() => _SanadVerifiedScreenState();
}

class _SanadVerifiedScreenState extends State<SanadVerifiedScreen> {
  bool _isSaving = false;

  Future<void> _handleConfirm() async {
    setState(() => _isSaving = true);

    try {
      await sl<IdentityVerificationService>().saveVerification(
        fullName: widget.info.fullName,
        nationalId: widget.info.nationalId,
        method: 'sanad',
      );
      widget.onVerified?.call(widget.info.fullName);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IdentityConfirmLayout(
            title: 'Verified with Sanad',
            subtitle: 'Please confirm the details retrieved from Sanad before continuing.',
            info: widget.info,
            onBack: () => Navigator.pop(context),
            onConfirm: _isSaving ? () {} : _handleConfirm,
          ),
          if (_isSaving)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
