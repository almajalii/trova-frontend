import 'package:flutter/material.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/identity-verification/logic/identity_info.dart';
import 'package:trova/features/identity-verification/logic/identity_verification_service.dart';
import 'package:trova/features/identity-verification/presentation/widget/scan_identity_confirm_layout.dart';

class ScanVerifiedScreen extends StatefulWidget {
  final IdentityInfo info;
  final VoidCallback? onVerified;

  const ScanVerifiedScreen({super.key, required this.info, this.onVerified});

  @override
  State<ScanVerifiedScreen> createState() => _ScanVerifiedScreenState();
}

class _ScanVerifiedScreenState extends State<ScanVerifiedScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _nationalIdController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.info.fullName);
    _nationalIdController = TextEditingController(text: widget.info.nationalId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final name = _nameController.text.trim();
    final nationalId = _nationalIdController.text.trim();

    if (name.isEmpty || nationalId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill in both fields before continuing.')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      await sl<IdentityVerificationService>().saveVerification(fullName: name, nationalId: nationalId, method: 'scan');
      widget.onVerified?.call();
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
      body: ScanIdentityConfirmLayout(
        title: 'ID Scanned Successfully',
        subtitle: 'Please confirm the details we read from your ID before continuing.',
        nameController: _nameController,
        nationalIdController: _nationalIdController,
        isSaving: _isSaving,
        onBack: () => Navigator.pop(context),
        onConfirm: _handleConfirm,
      ),
    );
  }
}
