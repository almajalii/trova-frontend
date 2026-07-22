// guarantee_shared.dart
//
// Shared presentational pieces for the 6-step guarantee flow, styled to
// match the rest of the app (AppText/Button/InputField, DetailInfoCard-style
// bordered rows) instead of raw Material widgets with default grey styling.
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';

/// Section label above an input, matching the `_Label` pattern used in
/// post-project's layout.
class GuaranteeLabel extends StatelessWidget {
  final String text;
  const GuaranteeLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppText(
        text: text,
        textSize: 13,
        fontWeight: FontWeight.w600,
        textColor: colors.onSurface,
        textAlign: TextAlign.start,
      ),
    );
  }
}

/// Bordered, rounded card of label/value rows — same visual language as
/// bid-detail's DetailInfoCard (radius 16, surfaceBright border, divider
/// between rows).
class GuaranteeInfoCard extends StatelessWidget {
  final List<MapEntry<String, String>> rows;
  const GuaranteeInfoCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.surfaceBright),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          final row = entry.value;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: isLast ? null : Border(bottom: BorderSide(color: colors.surfaceBright)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText(
                    text: row.key,
                    textSize: 13,
                    textColor: colors.secondary.withValues(alpha: 0.6),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppText(
                    text: row.value.isEmpty ? '—' : row.value,
                    textSize: 13,
                    fontWeight: FontWeight.w600,
                    textColor: colors.onSurface,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A field-shaped, bordered box for displaying auto-filled/non-editable
/// values (e.g. Project ID) — same rounded-12/surfaceBright box used by
/// InputField and the app's dropdown fields, just without a controller.
class GuaranteeReadOnlyField extends StatelessWidget {
  final String text;
  final String placeholder;
  const GuaranteeReadOnlyField({super.key, required this.text, this.placeholder = ''});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isEmpty = text.isEmpty;

    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.surfaceBright),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AppText(
        text: isEmpty ? placeholder : text,
        textSize: 15,
        fontWeight: isEmpty ? FontWeight.w500 : FontWeight.w600,
        textColor: isEmpty ? colors.surfaceBright : colors.onSurface,
        textAlign: TextAlign.start,
      ),
    );
  }
}

/// A tappable, field-shaped box used for date pickers — same shape as
/// GuaranteeReadOnlyField but with a chevron affordance and tap handler.
class GuaranteePickerField extends StatelessWidget {
  final String text;
  final String placeholder;
  final VoidCallback onTap;
  const GuaranteePickerField({super.key, required this.text, required this.placeholder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isEmpty = text.isEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.surfaceBright),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                text: isEmpty ? placeholder : text,
                textSize: 14,
                fontWeight: isEmpty ? FontWeight.w500 : FontWeight.w600,
                textColor: isEmpty ? colors.surfaceBright : colors.onSurface,
                textAlign: TextAlign.start,
              ),
            ),
            Icon(Icons.calendar_today_outlined, size: 16, color: colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// Dropdown field styled like `_AppDropdown` in post-project — same
/// rounded-12/surfaceBright box, `expand_more` icon.
class GuaranteeDropdownField<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const GuaranteeDropdownField({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.surfaceBright),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: TextStyle(color: colors.surfaceBright, fontSize: 15, fontWeight: FontWeight.w500)),
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: colors.onSurface),
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: colors.onSurface),
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(labelBuilder(item)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// Multi-line text field with the same decoration used elsewhere in the
/// app for freeform text (e.g. post-project's description field).
class GuaranteeMultilineField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const GuaranteeMultilineField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 3,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(color: colors.onSurface, fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: colors.surfaceBright, fontSize: 15, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.surfaceBright),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.surfaceBright),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}

/// A bordered card row used by the Documents step (upload rows) and by
/// Declarations (checkbox rows) — same rounded-16/surfaceBright container
/// language as the rest of the flow.
class GuaranteeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const GuaranteeCard({super.key, required this.child, this.padding = const EdgeInsets.all(14)});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.surfaceBright),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
