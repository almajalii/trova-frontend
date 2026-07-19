import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bank-connection/presentation/screens/connect_bank_account_screen.dart';
import 'package:trova/features/company-details/logic/company_details_model.dart';
import 'package:trova/features/company-details/logic/company_details_service.dart';
import 'package:trova/features/company-details/presentation/bloc/company_details_bloc.dart';
import 'package:trova/features/company-details/presentation/bloc/company_details_event.dart';
import 'package:trova/features/company-details/presentation/bloc/company_details_state.dart';
import 'package:trova/features/company-details/presentation/widget/company_details_layout.dart';

class CompanyDetailsScreen extends StatefulWidget {
  /// Called once company details are saved successfully. Defaults to
  /// pushing ConnectBankAccountScreen (the next step in the onboarding
  /// chain) if not provided.
  final VoidCallback? onSaved;

  const CompanyDetailsScreen({super.key, this.onSaved});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  late final CompanyDetailsBloc _bloc;

  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _yearsInOperationController = TextEditingController();
  final _teamSizeController = TextEditingController();
  final _annualRevenueController = TextEditingController();

  List<String> _selectedSectors = [];
  String? _sectorsErrorText;

  // Set once the initial GET resolves (found or not-found), so a later
  // CompanyDetailsError is known to be a submit error, not a fetch error.
  bool _hasResolvedInitialFetch = false;

  @override
  void initState() {
    super.initState();
    _bloc = CompanyDetailsBloc(companyDetailsService: sl<CompanyDetailsService>());
    _bloc.add(const CompanyDetailsRequested());
  }

  @override
  void dispose() {
    _bloc.close();
    _companyNameController.dispose();
    _registrationNumberController.dispose();
    _yearsInOperationController.dispose();
    _teamSizeController.dispose();
    _annualRevenueController.dispose();
    super.dispose();
  }

  void _prefillFrom(CompanyDetailsRecord record) {
    _companyNameController.text = record.companyName;
    _selectedSectors = List<String>.from(record.sectors);
    _registrationNumberController.text = record.registrationNumber;
    _yearsInOperationController.text = record.yearsInOperation.toString();
    _teamSizeController.text = record.teamSize.toString();
    _annualRevenueController.text = record.annualRevenueJod.toString();
  }

  void _submit() {
    final formValid = _formKey.currentState!.validate();
    final sectorsValid = _selectedSectors.isNotEmpty;
    setState(() {
      _sectorsErrorText = sectorsValid ? null : 'Select at least one sector';
    });
    if (!formValid || !sectorsValid) return;

    final draft = CompanyDetailsDraft(
      companyName: _companyNameController.text.trim(),
      sectors: _selectedSectors,
      registrationNumber: _registrationNumberController.text.trim(),
      yearsInOperation: int.tryParse(_yearsInOperationController.text) ?? 0,
      teamSize: int.tryParse(_teamSizeController.text) ?? 0,
      annualRevenueJod: double.tryParse(_annualRevenueController.text) ?? 0,
    );
    _bloc.add(CompanyDetailsSubmitted(draft: draft));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<CompanyDetailsBloc, CompanyDetailsState>(
          listener: (context, state) {
            if (state is CompanyDetailsFetched) {
              _hasResolvedInitialFetch = true;
              _prefillFrom(state.record);
            }
            if (state is CompanyDetailsNotFound) {
              _hasResolvedInitialFetch = true;
            }
            if (state is CompanyDetailsError && _hasResolvedInitialFetch) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is CompanyDetailsSuccess) {
              if (widget.onSaved != null) {
                widget.onSaved!.call();
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ConnectBankAccountScreen()),
                );
              }
            }
          },
          builder: (context, state) {
            if (state is CompanyDetailsInitial || state is CompanyDetailsFetchLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CompanyDetailsError && !_hasResolvedInitialFetch) {
              return _FetchErrorView(
                message: state.message,
                onRetry: () => _bloc.add(const CompanyDetailsRequested()),
              );
            }

            final isLoading = state is CompanyDetailsLoading;
            return CompanyDetailsLayout(
              formKey: _formKey,
              companyNameController: _companyNameController,
              selectedSectors: _selectedSectors,
              onSectorsChanged: (updated) {
                setState(() {
                  _selectedSectors = updated;
                  if (updated.isNotEmpty) _sectorsErrorText = null;
                });
              },
              sectorsErrorText: _sectorsErrorText,
              registrationNumberController: _registrationNumberController,
              yearsInOperationController: _yearsInOperationController,
              teamSizeController: _teamSizeController,
              annualRevenueController: _annualRevenueController,
              isLoading: isLoading,
              onBack: () => Navigator.of(context).maybePop(),
              onSubmit: _submit,
            );
          },
        ),
      ),
    );
  }
}

class _FetchErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FetchErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(text: message, textSize: 14, textColor: colors.onSurface, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Button(
              text: 'Retry',
              textColor: Colors.white,
              borderRadius: 10,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: 160,
              buttonHeight: 44,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
