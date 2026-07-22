import 'package:flutter/material.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/settings/logic/change_password_service.dart';
import 'package:trova/features/settings/presentation/widget/change_password_layout.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await sl<ChangePasswordService>().changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated successfully')));
        Navigator.of(context).pop();
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangePasswordLayout(
        formKey: _formKey,
        currentPasswordController: _currentPasswordController,
        newPasswordController: _newPasswordController,
        confirmPasswordController: _confirmPasswordController,
        isLoading: _isLoading,
        onBack: () => Navigator.of(context).maybePop(),
        onSubmit: _submit,
      ),
    );
  }
}
