import 'package:trova/features/project-bid-detail/logic/projectdetailbid_model.dart';

class ProjectBidDetailService {
  static final List<Project> _mockProjects = [
    Project(
      id: '1',
      title: 'Al-Noor Tower Construction',
      postedBy: 'Al-Noor Development',
      sector: 'Construction',
      location: 'Abdali, Amman',
      contractValue: 240000,
      timeline: '14 months (Aug 2026 - Oct 2027)',
      milestones: 'Foundation - M2, Structure - M8, Handover - M14',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '20% upfront / 60% milestones / 20% completion',
      minimumScore: 80,
      minimumClassification: 'Class B or higher',
      bidDeadline: DateTime(2026, 7, 19),
      description: '18-floor mixed-use tower in Abdali. Structural, MEP, and finishing works. 14-month timeline.',
    ),
    Project(
      id: '2',
      title: 'Riverside Complex Phase 2',
      postedBy: 'Riverside Holdings',
      sector: 'Real Estate',
      location: 'Amman, Jordan',
      contractValue: 1200000,
      timeline: '9 months',
      milestones: 'Design - M2, Build - M7, Handover - M9',
      guaranteeTypeRequired: 'Bid Bond',
      paymentTerms: '30% upfront / 50% milestones / 20% completion',
      minimumScore: 90,
      minimumClassification: 'Class A',
      bidDeadline: DateTime(2026, 8, 1),
      description: 'Second phase of Riverside residential complex.',
    ),
    // add more matching your card ids as needed
  ];

  Project getProjectById(String id) {
    return _mockProjects.firstWhere(
      (p) => p.id == id,
      orElse: () => _mockProjects.first,
    );
  }

  Future<void> submitBid({required String projectId, required double bidAmount}) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}