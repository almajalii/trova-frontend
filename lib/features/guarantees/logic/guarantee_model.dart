import 'dart:io';
import 'package:equatable/equatable.dart';

enum GuaranteeType { performance, bidBond, advancePayment, retention }

class GuaranteeRequestModel extends Equatable {
  // Step 1 - Applicant
  final String? contractorId;
  final String? legalCompanyName;
  final String? registrationNumber;
  final String? taxVatNumber;
  final String? registeredAddress;
  final String? primaryContact;
  final String? primaryEmail;
  final String? primaryPhone;

  // Step 2 - Project
  final String? projectId;
  final String? projectName;
  final String? location;
  final double? contractValue;
  final String? description;
  final String? contractDuration;

  // Step 3 - Guarantee Details
  final GuaranteeType? guaranteeType;
  final double? guaranteedAmount;
  final String currency;
  final DateTime? validityStart;
  final DateTime? validityExpiry;
  final String? specialConditions;

  // Step 4 - Beneficiary
  final String? beneficiaryId;
  final String? beneficiaryCompanyName;
  final String? beneficiaryAddress;
  final String? beneficiaryContact;
  final String? beneficiaryEmail;
  final String? beneficiaryPhone;

  // Step 5 - Documents
  final File? signedContractFile;
  final File? letterOfAwardFile;
  final List<File> otherDocuments;

  // Step 6 - Declarations
  final bool confirmAccurate;
  final bool agreeIndemnify;
  final bool acceptTerms;
  final String? signatureName;

  const GuaranteeRequestModel({
    this.contractorId,
    this.legalCompanyName,
    this.registrationNumber,
    this.taxVatNumber,
    this.registeredAddress,
    this.primaryContact,
    this.primaryEmail,
    this.primaryPhone,
    this.projectId,
    this.projectName,
    this.location,
    this.contractValue,
    this.description,
    this.contractDuration,
    this.guaranteeType,
    this.guaranteedAmount,
    this.currency = 'JOD',
    this.validityStart,
    this.validityExpiry,
    this.specialConditions,
    this.beneficiaryId,
    this.beneficiaryCompanyName,
    this.beneficiaryAddress,
    this.beneficiaryContact,
    this.beneficiaryEmail,
    this.beneficiaryPhone,
    this.signedContractFile,
    this.letterOfAwardFile,
    this.otherDocuments = const [],
    this.confirmAccurate = false,
    this.agreeIndemnify = false,
    this.acceptTerms = false,
    this.signatureName,
  });

  GuaranteeRequestModel copyWith({
    String? contractorId,
    String? legalCompanyName,
    String? registrationNumber,
    String? taxVatNumber,
    String? registeredAddress,
    String? primaryContact,
    String? primaryEmail,
    String? primaryPhone,
    String? projectId,
    String? projectName,
    String? location,
    double? contractValue,
    String? description,
    String? contractDuration,
    GuaranteeType? guaranteeType,
    double? guaranteedAmount,
    String? currency,
    DateTime? validityStart,
    DateTime? validityExpiry,
    String? specialConditions,
    String? beneficiaryId,
    String? beneficiaryCompanyName,
    String? beneficiaryAddress,
    String? beneficiaryContact,
    String? beneficiaryEmail,
    String? beneficiaryPhone,
    File? signedContractFile,
    File? letterOfAwardFile,
    List<File>? otherDocuments,
    bool? confirmAccurate,
    bool? agreeIndemnify,
    bool? acceptTerms,
    String? signatureName,
  }) {
    return GuaranteeRequestModel(
      contractorId: contractorId ?? this.contractorId,
      legalCompanyName: legalCompanyName ?? this.legalCompanyName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      taxVatNumber: taxVatNumber ?? this.taxVatNumber,
      registeredAddress: registeredAddress ?? this.registeredAddress,
      primaryContact: primaryContact ?? this.primaryContact,
      primaryEmail: primaryEmail ?? this.primaryEmail,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      location: location ?? this.location,
      contractValue: contractValue ?? this.contractValue,
      description: description ?? this.description,
      contractDuration: contractDuration ?? this.contractDuration,
      guaranteeType: guaranteeType ?? this.guaranteeType,
      guaranteedAmount: guaranteedAmount ?? this.guaranteedAmount,
      currency: currency ?? this.currency,
      validityStart: validityStart ?? this.validityStart,
      validityExpiry: validityExpiry ?? this.validityExpiry,
      specialConditions: specialConditions ?? this.specialConditions,
      beneficiaryId: beneficiaryId ?? this.beneficiaryId,
      beneficiaryCompanyName: beneficiaryCompanyName ?? this.beneficiaryCompanyName,
      beneficiaryAddress: beneficiaryAddress ?? this.beneficiaryAddress,
      beneficiaryContact: beneficiaryContact ?? this.beneficiaryContact,
      beneficiaryEmail: beneficiaryEmail ?? this.beneficiaryEmail,
      beneficiaryPhone: beneficiaryPhone ?? this.beneficiaryPhone,
      signedContractFile: signedContractFile ?? this.signedContractFile,
      letterOfAwardFile: letterOfAwardFile ?? this.letterOfAwardFile,
      otherDocuments: otherDocuments ?? this.otherDocuments,
      confirmAccurate: confirmAccurate ?? this.confirmAccurate,
      agreeIndemnify: agreeIndemnify ?? this.agreeIndemnify,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      signatureName: signatureName ?? this.signatureName,
    );
  }

  @override
  List<Object?> get props => [
        contractorId, legalCompanyName, registrationNumber, taxVatNumber,
        registeredAddress, primaryContact, primaryEmail, primaryPhone,
        projectId, projectName, location, contractValue, description,
        contractDuration, guaranteeType, guaranteedAmount, currency,
        validityStart, validityExpiry, specialConditions, beneficiaryId,
        beneficiaryCompanyName, beneficiaryAddress, beneficiaryContact,
        beneficiaryEmail, beneficiaryPhone, signedContractFile,
        letterOfAwardFile, otherDocuments, confirmAccurate,
        agreeIndemnify, acceptTerms, signatureName,
      ];
}