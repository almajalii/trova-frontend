import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_model.dart';

class ConnectBankLayout extends StatelessWidget {
  final List<BankOption> banks;
  final VoidCallback onBack;
  final ValueChanged<BankOption> onBankTap;

  const ConnectBankLayout({super.key, required this.banks, required this.onBack, required this.onBankTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 8, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back, color: colors.onSurface), padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
            const SizedBox(height: 8),
            AppTitle(title: 'Connect Your Bank', size: 24, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.start),
            const SizedBox(height: 12),
            AppText(
              text: 'Securely link your bank account via Open Finance so we can generate your capability score.',
              textSize: 14,
              textColor: colors.onSurfaceVariant,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: banks.length + 1,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  if (i == banks.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AppText(
                        text: 'Your data is encrypted and only used to calculate your score. You can revoke access anytime.',
                        textSize: 12,
                        textColor: colors.onSurfaceVariant,
                      ),
                    );
                  }
                  return _BankRow(bank: banks[i], onTap: () => onBankTap(banks[i]));
                },
              ),
            ),
          ],
        ),
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
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(10)),
              child: Text(bank.initials, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 15, color: colors.primary)),
            ),
            const SizedBox(width: 14),
            Expanded(child: AppText(text: bank.name, textSize: 14, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start)),
            Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
