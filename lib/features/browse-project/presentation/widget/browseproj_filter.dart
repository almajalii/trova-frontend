import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/features/browse-project/logic/browseproj_filter.dart';

class FilterProjectsSheet extends StatefulWidget {
  final ProjectsFilter initialFilter;

  const FilterProjectsSheet({super.key, required this.initialFilter});

  @override
  State<FilterProjectsSheet> createState() => _FilterProjectsSheetState();
}

class _FilterProjectsSheetState extends State<FilterProjectsSheet> {
  static const _sectors = ['Construction', 'Infrastructure', 'Industrial', 'MEP', 'Renovation & Fit-out'];
  static const _sortOptions = {
    'value_desc': 'Contract Value: High to Low',
    'value_asc': 'Contract Value: Low to High',
  };

  late String? _selectedSector;
  late TextEditingController _minController;
  late TextEditingController _maxController;
  late String _sortBy;

  @override
  void initState() {
    super.initState();
    _selectedSector = widget.initialFilter.sector;
    _minController = TextEditingController(
      text: widget.initialFilter.minValue?.toStringAsFixed(0) ?? '',
    );
    _maxController = TextEditingController(
      text: widget.initialFilter.maxValue?.toStringAsFixed(0) ?? '',
    );
    _sortBy = widget.initialFilter.sortBy;
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _selectedSector = null;
      _minController.clear();
      _maxController.clear();
      _sortBy = 'value_desc';
    });
  }

  void _apply() {
    final filter = ProjectsFilter(
      sector: _selectedSector,
      minValue: double.tryParse(_minController.text),
      maxValue: double.tryParse(_maxController.text),
      sortBy: _sortBy,
    );
    Navigator.of(context).pop(filter);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Filter Projects',
                textSize: 18,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.left,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppText(text: 'Sector', fontWeight: FontWeight.w600, textAlign: TextAlign.left),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sectors.map((sector) {
              final isSelected = _selectedSector == sector;
              return ChoiceChip(
                label: Text(sector),
                selected: isSelected,
                onSelected: (_) => setState(() => _selectedSector = isSelected ? null : sector),
                selectedColor: colors.primary,
                backgroundColor: colors.surfaceBright,
                labelStyle: TextStyle(color: isSelected ? colors.onPrimary : colors.onSurface),
                shape: StadiumBorder(side: BorderSide(color: colors.surfaceBright)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          AppText(text: 'Contract Value (JOD)', fontWeight: FontWeight.w600, textAlign: TextAlign.left),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Min',
                    filled: true,
                    fillColor: colors.surfaceBright.withValues(alpha: 0.3),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _maxController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Max',
                    filled: true,
                    fillColor: colors.surfaceBright.withValues(alpha: 0.3),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppText(text: 'Sort By', fontWeight: FontWeight.w600, textAlign: TextAlign.left),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: colors.surfaceBright.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _sortBy,
                isExpanded: true,
                items: _sortOptions.entries
                    .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _sortBy = value);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Button(
                  text: 'Reset',
                  textColor: colors.primary,
                  borderRadius: 12,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  buttonWidth: double.infinity,
                  buttonHeight: 46,
                  elevation: 0,
                  buttonColor: colors.surface,
                  borderColor: colors.primary,
                  onPressed: _reset,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Button(
                  text: 'Apply Filters',
                  textColor: colors.onPrimary,
                  borderRadius: 12,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  buttonWidth: double.infinity,
                  buttonHeight: 46,
                  elevation: 0,
                  onPressed: _apply,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}