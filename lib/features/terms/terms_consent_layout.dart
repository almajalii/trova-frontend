import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/terms/terms_content.dart';

class TermsConsentLayout extends StatelessWidget {
  final ScrollController scrollController;
  final bool reachedBottom;
  final bool agreed;
  final ValueChanged<bool> onAgreedChanged;
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const TermsConsentLayout({
    super.key,
    required this.scrollController,
    required this.reachedBottom,
    required this.agreed,
    required this.onAgreedChanged,
    required this.onContinue,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final canContinue = reachedBottom && agreed;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back, color: colors.onSurface),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),

            const SizedBox(height: 8),

            AppTitle(
              title: 'Terms & Conditions',
              size: 24,
              weight: FontWeight.bold,
              titleColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 6),

            AppText(
              text: 'Please review and accept to continue',
              textSize: 14,
              textColor: colors.onSurfaceVariant,
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colors.surfaceBright),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildTermsBlocks(colors),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (!reachedBottom)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppText(
                  text: 'Scroll to the bottom to continue',
                  textSize: 12,
                  textColor: colors.onSurfaceVariant,
                  textAlign: TextAlign.start,
                ),
              ),

            Row(
              children: [
                Checkbox(
                  value: agreed,
                  onChanged: reachedBottom ? (value) => onAgreedChanged(value ?? false) : null,
                  activeColor: colors.primary,
                ),
                Expanded(
                  child: AppText(
                    text: 'I have read and agree to the Terms and Conditions',
                    textSize: 13,
                    textColor: colors.onSurface,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Button(
              text: 'Agree & Continue',
              textColor: colors.onPrimary,
              borderRadius: 12,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: context.buttonSizeH,
              onPressed: canContinue ? onContinue : null,
            ),

            SizedBox(height: context.vertical),
          ],
        ),
      ),
    );
  }
}

/// Parses [trovaTermsAndConditions] into styled widgets.
/// Supported syntax only: '# heading', '## subheading', '* bullet',
/// '---' divider, and inline '**bold**'. The very first '# ' line
/// (the document title) is skipped since it's shown in the screen header.
List<Widget> _buildTermsBlocks(ColorScheme colors) {
  final lines = trovaTermsAndConditions.split('\n');
  final widgets = <Widget>[];
  final baseStyle = GoogleFonts.inter(fontSize: 13, height: 1.5, color: colors.onSurface);

  bool skippedTitle = false;

  for (final rawLine in lines) {
    final line = rawLine.trim();

    if (line.isEmpty) {
      widgets.add(const SizedBox(height: 10));
      continue;
    }

    if (line == '---') {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: colors.surfaceBright, height: 1),
      ));
      continue;
    }

    if (line.startsWith('## ')) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: RichText(
          text: TextSpan(
            children: _parseInline(line.substring(3).trim(), baseStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
      ));
      continue;
    }

    if (line.startsWith('# ')) {
      if (!skippedTitle) {
        skippedTitle = true;
        continue;
      }
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: RichText(
          text: TextSpan(
            children: _parseInline(line.substring(2).trim(), baseStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ));
      continue;
    }

    if (line.startsWith('* ')) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•  ', style: baseStyle),
            Expanded(child: RichText(text: TextSpan(children: _parseInline(line.substring(2).trim(), baseStyle)))),
          ],
        ),
      ));
      continue;
    }

    widgets.add(Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(text: TextSpan(children: _parseInline(line, baseStyle))),
    ));
  }

  return widgets;
}

/// Splits text on '**bold**' markers into plain/bold TextSpans.
List<InlineSpan> _parseInline(String text, TextStyle baseStyle) {
  final spans = <InlineSpan>[];
  final regex = RegExp(r'\*\*(.*?)\*\*');
  int lastIndex = 0;

  for (final match in regex.allMatches(text)) {
    if (match.start > lastIndex) {
      spans.add(TextSpan(text: text.substring(lastIndex, match.start), style: baseStyle));
    }
    spans.add(TextSpan(text: match.group(1), style: baseStyle.copyWith(fontWeight: FontWeight.w700)));
    lastIndex = match.end;
  }

  if (lastIndex < text.length) {
    spans.add(TextSpan(text: text.substring(lastIndex), style: baseStyle));
  }

  return spans;
}