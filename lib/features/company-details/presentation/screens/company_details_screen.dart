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

  // Company Legal Info
  final _legalCompanyNameController = TextEditingController();
  final _tradingNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _taxVatNumberController = TextEditingController();
  final _legalStructureController = TextEditingController();
  final _yearOfEstablishmentController = TextEditingController();
  final _registeredAddressController = TextEditingController();
  final _countryOfRegistrationController = TextEditingController();

  // Contact Information
  final _primaryContactNameController = TextEditingController();
  final _positionTitleController = TextEditingController();
  final _primaryEmailController = TextEditingController();
  final _primaryPhoneNumberController = TextEditingController();

  // Business Qualifications
  final _businessLicenseNumberController = TextEditingController();
  final _contractorClassificationGradeController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _teamSizeController = TextEditingController();
  final _annualRevenueController = TextEditingController();

  // Banking Basics
  final _primaryBankNameController = TextEditingController();
  final _ibanNumberController = TextEditingController();
  final _swiftBicCodeController = TextEditingController();
  final _bankBranchNameCityController = TextEditingController();

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
    _legalCompanyNameController.dispose();
    _tradingNameController.dispose();
    _registrationNumberController.dispose();
    _taxVatNumberController.dispose();
    _legalStructureController.dispose();
    _yearOfEstablishmentController.dispose();
    _registeredAddressController.dispose();
    _countryOfRegistrationController.dispose();
    _primaryContactNameController.dispose();
    _positionTitleController.dispose();
    _primaryEmailController.dispose();
    _primaryPhoneNumberController.dispose();
    _businessLicenseNumberController.dispose();
    _contractorClassificationGradeController.dispose();
    _yearsOfExperienceController.dispose();
    _teamSizeController.dispose();
    _annualRevenueController.dispose();
    _primaryBankNameController.dispose();
    _ibanNumberController.dispose();
    _swiftBicCodeController.dispose();
    _bankBranchNameCityController.dispose();
    super.dispose();
  }

  void _prefillFrom(CompanyDetailsRecord record) {
    _legalCompanyNameController.text = record.legalCompanyName;
    _tradingNameController.text = record.tradingName;
    _registrationNumberController.text = record.registrationNumber;
    _taxVatNumberController.text = record.taxVatNumber;
    _legalStructureController.text = record.legalStructure;
    _yearOfEstablishmentController.text = record.yearOfEstablishment.toString();
    _registeredAddressController.text = record.registeredAddress;
    _countryOfRegistrationController.text = record.countryOfRegistration;
    _primaryContactNameController.text = record.primaryContactName;
    _positionTitleController.text = record.positionTitle;
    _primaryEmailController.text = record.primaryEmail;
    _primaryPhoneNumberController.text = record.primaryPhoneNumber;
    _businessLicenseNumberController.text = record.businessLicenseNumber;
    _contractorClassificationGradeController.text = record.contractorClassificationGrade;
    _selectedSectors = List<String>.from(record.sectors);
    _yearsOfExperienceController.text = record.yearsOfExperience.toString();
    _teamSizeController.text = record.teamSize.toString();
    _annualRevenueController.text = record.annualRevenueJod.toString();
    _primaryBankNameController.text = record.primaryBankName;
    _ibanNumberController.text = record.ibanNumber;
    _swiftBicCodeController.text = record.swiftBicCode;
    _bankBranchNameCityController.text = record.bankBranchNameCity;
  }

  void _submit() {
    final formValid = _formKey.currentState!.validate();
    final sectorsValid = _selectedSectors.isNotEmpty;
    setState(() {
      _sectorsErrorText = sectorsValid ? null : 'Select at least one area of expertise';
    });
    if (!formValid || !sectorsValid) return;

    final draft = CompanyDetailsDraft(
      legalCompanyName: _legalCompanyNameController.text.trim(),
      tradingName: _tradingNameController.text.trim(),
      registrationNumber: _registrationNumberController.text.trim(),
      taxVatNumber: _taxVatNumberController.text.trim(),
      legalStructure: _legalStructureController.text.trim(),
      yearOfEstablishment: int.tryParse(_yearOfEstablishmentController.text) ?? 0,
      registeredAddress: _registeredAddressController.text.trim(),
      countryOfRegistration: _countryOfRegistrationController.text.trim(),
      primaryContactName: _primaryContactNameController.text.trim(),
      positionTitle: _positionTitleController.text.trim(),
      primaryEmail: _primaryEmailController.text.trim(),
      primaryPhoneNumber: _primaryPhoneNumberController.text.trim(),
      businessLicenseNumber: _businessLicenseNumberController.text.trim(),
      contractorClassificationGrade: _contractorClassificationGradeController.text.trim(),
      sectors: _selectedSectors,
      yearsOfExperience: int.tryParse(_yearsOfExperienceController.text) ?? 0,
      teamSize: int.tryParse(_teamSizeController.text) ?? 0,
      annualRevenueJod: double.tryParse(_annualRevenueController.text) ?? 0,
      primaryBankName: _primaryBankNameController.text.trim(),
      ibanNumber: _ibanNumberController.text.trim(),
      swiftBicCode: _swiftBicCodeController.text.trim(),
      bankBranchNameCity: _bankBranchNameCityController.text.trim(),
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
                Navigator.of(
                  context,
                ).pushReplacement(MaterialPageRoute(builder: (_) => const ConnectBankAccountScreen()));
              }
            }
          },
          builder: (context, state) {
            if (state is CompanyDetailsInitial || state is CompanyDetailsFetchLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CompanyDetailsError && !_hasResolvedInitialFetch) {
              return _FetchErrorView(message: state.message, onRetry: () => _bloc.add(const CompanyDetailsRequested()));
            }

            final isLoading = state is CompanyDetailsLoading;
            return CompanyDetailsLayout(
              formKey: _formKey,
              legalCompanyNameController: _legalCompanyNameController,
              tradingNameController: _tradingNameController,
              registrationNumberController: _registrationNumberController,
              taxVatNumberController: _taxVatNumberController,
              legalStructureController: _legalStructureController,
              yearOfEstablishmentController: _yearOfEstablishmentController,
              registeredAddressController: _registeredAddressController,
              countryOfRegistrationController: _countryOfRegistrationController,
              primaryContactNameController: _primaryContactNameController,
              positionTitleController: _positionTitleController,
              primaryEmailController: _primaryEmailController,
              primaryPhoneNumberController: _primaryPhoneNumberController,
              businessLicenseNumberController: _businessLicenseNumberController,
              contractorClassificationGradeController: _contractorClassificationGradeController,
              selectedSectors: _selectedSectors,
              onSectorsChanged: (updated) {
                setState(() {
                  _selectedSectors = updated;
                  if (updated.isNotEmpty) _sectorsErrorText = null;
                });
              },
              sectorsErrorText: _sectorsErrorText,
              yearsOfExperienceController: _yearsOfExperienceController,
              teamSizeController: _teamSizeController,
              annualRevenueController: _annualRevenueController,
              primaryBankNameController: _primaryBankNameController,
              ibanNumberController: _ibanNumberController,
              swiftBicCodeController: _swiftBicCodeController,
              bankBranchNameCityController: _bankBranchNameCityController,
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
