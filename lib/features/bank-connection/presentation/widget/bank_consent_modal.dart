import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_model.dart';

/// Bottom-sheet consent modal for Open Finance authorization. Mirrors the
/// Figma "Bank Consent Modal" — shown from ConnectBankAccountScreen.
class BankConsentModal extends StatefulWidget {
  final BankOption bank;
  final bool isAuthorizing;
  final void Function(double remainingDebtCapacityJod, int numberOfDelinquentDebts, int numberOfCurrentDebts)
  onAuthorize;
  final VoidCallback onCancel;

  const BankConsentModal({
    super.key,
    required this.bank,
    required this.isAuthorizing,
    required this.onAuthorize,
    required this.onCancel,
  });

  @override
  State<BankConsentModal> createState() => _BankConsentModalState();
}

class _BankConsentModalState extends State<BankConsentModal> {
  final _formKey = GlobalKey<FormState>();
  final _remainingDebtCapacityController = TextEditingController();
  final _delinquentDebtsController = TextEditingController();
  final _currentDebtsController = TextEditingController();

  @override
  void dispose() {
    _remainingDebtCapacityController.dispose();
    _delinquentDebtsController.dispose();
    _currentDebtsController.dispose();
    super.dispose();
  }

  String? _validateRemainingDebtCapacity(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final parsed = double.tryParse(value.trim());
    if (parsed == null) return 'Enter a valid number';
    if (parsed < 0) return 'Must be non-negative';
    return null;
  }

  String? _validateDelinquentDebts(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Enter a whole number';
    if (parsed < 0) return 'Must be non-negative';
    return null;
  }

  String? _validateCurrentDebts(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final parsed = int.tryParse(value.trim());
    if (parsed == null) return 'Enter a whole number';
    if (parsed < 0) return 'Must be non-negative';
    return null;
  }

  void _handleAuthorize() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final remainingDebtCapacityJod = double.parse(_remainingDebtCapacityController.text.trim());
    final numberOfDelinquentDebts = int.parse(_delinquentDebtsController.text.trim());
    final numberOfCurrentDebts = int.parse(_currentDebtsController.text.trim());
    widget.onAuthorize(remainingDebtCapacityJod, numberOfDelinquentDebts, numberOfCurrentDebts);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bank = widget.bank;
    final isAuthorizing = widget.isAuthorizing;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        padding: const EdgeInsets.all(24),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(10)),
                    child: Text(bank.initials, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white)),
                  ),
                  IconButton(onPressed: isAuthorizing ? null : widget.onCancel, icon: Icon(Icons.close, color: colors.onSurfaceVariant)),
                ],
              ),
              AppText(text: 'Connect with ${bank.name}', textSize: 19, fontWeight: FontWeight.w700, textColor: colors.onSurface, textAlign: TextAlign.start),
              const SizedBox(height: 8),
              AppText(text: "You'll be securely redirected to ${bank.name} to log in via Open Finance.", textSize: 13, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text: 'Trova will receive:', textSize: 12, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
                    const SizedBox(height: 8),
                    const _Bullet('Account balances & assets'),
                    const SizedBox(height: 6),
                    const _Bullet('Existing debt & repayment history'),
                    const SizedBox(height: 6),
                    const _Bullet('Transaction history'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              AppText(
                text: 'This data feeds into your Capability Score. Other companies can see your score and classification when you bid on their projects.',
                textSize: 11,
                textColor: colors.onSurfaceVariant,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              AppText(text: 'Remaining Debt Capacity (JOD)', textSize: 12, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
              const SizedBox(height: 6),
              InputField(
                controller: _remainingDebtCapacityController,
                hintText: 'e.g. 5000',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: _validateRemainingDebtCapacity,
              ),
              const SizedBox(height: 12),
              AppText(text: 'Number of Delinquent Debts', textSize: 12, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
              const SizedBox(height: 6),
              InputField(
                controller: _delinquentDebtsController,
                hintText: 'e.g. 0',
                keyboardType: TextInputType.number,
                validator: _validateDelinquentDebts,
              ),
              const SizedBox(height: 12),
              AppText(text: 'Number of Current Debts', textSize: 12, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
              const SizedBox(height: 6),
              InputField(
                controller: _currentDebtsController,
                hintText: 'e.g. 2',
                keyboardType: TextInputType.number,
                validator: _validateCurrentDebts,
              ),
              const SizedBox(height: 16),
              Button(
                text: isAuthorizing ? 'Authorizing...' : 'Authorize Access',
                textColor: Colors.white,
                borderRadius: 9,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                elevation: 0,
                buttonWidth: double.infinity,
                buttonHeight: 48,
                onPressed: isAuthorizing ? null : _handleAuthorize,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: isAuthorizing ? null : widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.surfaceBright, width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  ),
                  child: AppText(text: 'Cancel', textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurfaceVariant),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 8),
          child: Container(width: 4, height: 4, decoration: BoxDecoration(color: colors.onSurfaceVariant, shape: BoxShape.circle)),
        ),
        Expanded(child: AppText(text: text, textSize: 12, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start)),
      ],
    );
  }
}
