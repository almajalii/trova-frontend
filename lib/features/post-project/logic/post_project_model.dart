import 'package:equatable/equatable.dart';

// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// POST /api/projects
// {
//   "title": "Al-Noor Tower Construction",
//   "sector": "Construction",
//   "location": "Amman, Abdali District",
//   "contractValue": 240000,
//   "currency": "JOD",
//   "duration": "14 months (Aug 2026 – Oct 2027)",
//   "milestones": "Foundation - Month 2...",
//   "bidSubmissionDeadline": "2026-08-15T00:00:00.000",
//   "minimumRequiredScore": 80,
//   "minimumClassification": "B",      // enum: A | B | C
//   "guaranteeType": "Performance Guarantee",
//   "paymentTerms": "20% upfront / 60% at milestones / 20% on completion",
//   "description": "..."
// }
// → 201 { "data": { "projectId": "..." } }
// ───────────────────────────────────────────────────────────────────────

enum ClassificationCode { a, b, c }

extension ClassificationCodeX on ClassificationCode {
  String get apiValue {
    switch (this) {
      case ClassificationCode.a:
        return 'A';
      case ClassificationCode.b:
        return 'B';
      case ClassificationCode.c:
        return 'C';
    }
  }

  String get dropdownLabel {
    switch (this) {
      case ClassificationCode.a:
        return 'Class A or higher (Large+)';
      case ClassificationCode.b:
        return 'Class B or higher (Medium+)';
      case ClassificationCode.c:
        return 'Class C or higher (Any)';
    }
  }
}

class ProjectDraft extends Equatable {
  final String title;
  final String sector;
  final String location;
  final double contractValue;
  final String currency;
  final String duration;
  final String milestones;
  final DateTime bidSubmissionDeadline;
  final int minimumRequiredScore;
  final ClassificationCode minimumClassification;
  final String guaranteeType;
  final String paymentTerms;
  final String description;

  const ProjectDraft({
    required this.title,
    required this.sector,
    required this.location,
    required this.contractValue,
    this.currency = 'JOD',
    required this.duration,
    required this.milestones,
    required this.bidSubmissionDeadline,
    required this.minimumRequiredScore,
    required this.minimumClassification,
    required this.guaranteeType,
    required this.paymentTerms,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'sector': sector,
    'location': location,
    'contractValue': contractValue,
    'currency': currency,
    'duration': duration,
    'milestones': milestones,
    'bidSubmissionDeadline': bidSubmissionDeadline.toIso8601String(),
    'minimumRequiredScore': minimumRequiredScore,
    'minimumClassification': minimumClassification.apiValue,
    'guaranteeType': guaranteeType,
    'paymentTerms': paymentTerms,
    'description': description,
  };

  @override
  List<Object?> get props => [
    title,
    sector,
    location,
    contractValue,
    currency,
    duration,
    milestones,
    bidSubmissionDeadline,
    minimumRequiredScore,
    minimumClassification,
    guaranteeType,
    paymentTerms,
    description,
  ];
}
