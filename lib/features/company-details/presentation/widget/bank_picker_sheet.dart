import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_model.dart';

/// Scrollable "choose your bank" sheet — same list of banks as Connect Bank
/// Account (GET /bank-connection/banks), reused here so Primary Bank Name
/// is picked from a known-good list instead of typed freehand.
Future<BankOption?> showBankPickerSheet(BuildContext context, List<BankOption> banks) {
  return showModalBottomSheet<BankOption>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _BankPickerContent(banks: banks),
  );
}

class _BankPickerContent extends StatelessWidget {
  final List<BankOption> banks;
  const _BankPickerContent({required this.banks});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTitle(
                title: 'Select Your Bank',
                size: 20,
                weight: FontWeight.bold,
                titleColor: colors.onSurface,
                textAlign: TextAlign.start,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: banks.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _BankRow(bank: banks[i], onTap: () => Navigator.pop(context, banks[i])),
            ),
          ),
        ],
      ),
    );
  }
}

class _BankRow extends StatelessWidget {
  final BankOption bank;
  final VoidCallback onTap;
  const _BankRow({required this.bank, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(10)),
              child: Text(
                bank.initials,
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 13, color: colors.primary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppText(text: bank.name, textSize: 14, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
            ),
          ],
        ),
      ),
    );
  }
}
