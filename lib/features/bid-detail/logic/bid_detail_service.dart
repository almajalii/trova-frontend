// lib/features/biddetail/logic/bid_detail_service.dart

import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bid-detail/logic/bide_detail_model.dart';

class BidDetailService {
  final Dio dio;
  BidDetailService({required this.dio});

  Future<BidDetailModel> fetchBidDetail(String id) async {
    if (kUseMockBidDetail) {
      await Future.delayed(const Duration(milliseconds: 400));
      final detail = _mockDetails[id];
      if (detail == null) {
        throw Exception('Bid detail not found for id $id');
      }
      return detail;
    }

    try {
      final response = await dio.get('/bids/$id');
      return BidDetailModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Kept for local UI development / demos when kUseMockBidDetail is
  // flipped to true. Not used on the live path.
  static final Map<String, BidDetailModel> _mockDetails = {
    '1': const BidDetailModel(
      id: '1',
      projectTitle: 'Al-Noor Tower Construction',
      companyName: 'Al-Noor Development',
      status: 'pending',
      sector: 'Construction',
      location: 'Abdali, Amman',
      contractValue: 240000,
      timelineRange: '14 months (Aug 2026 – Oct 2027)',
      bidAmount: 238000,
      projectId: 'TRV-PRJ-40218',
      statusSteps: [
        StatusStepModel(label: 'Bid Submitted', date: 'Jul 12, 2026', state: BidStepState.current),
        StatusStepModel(label: 'Selected by Owner', state: BidStepState.pending),
        StatusStepModel(label: 'Confirmed', state: BidStepState.pending),
        StatusStepModel(label: 'Guarantee Applied & Active', state: BidStepState.pending),
        StatusStepModel(label: 'In Progress → Completed', state: BidStepState.pending),
      ],
    ),
    '2': const BidDetailModel(
      id: '2',
      projectTitle: 'Riverside Complex Phase 2',
      companyName: 'Riverside Holdings',
      status: 'rejected',
      sector: 'Real Estate',
      location: 'Riverside, Amman',
      contractValue: 1200000,
      timelineRange: '18 months (planned)',
      bidAmount: 1180000,
      projectId: 'TRV-PRJ-88104',
      bannerNote: 'Owner selected another contractor for this project.',
      statusSteps: [
        StatusStepModel(label: 'Bid Submitted', date: 'Jul 8, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Not Selected', date: 'Jul 16, 2026', state: BidStepState.rejected),
      ],
    ),
    '3': const BidDetailModel(
      id: '3',
      projectTitle: 'Zaytoonah Business Park',
      companyName: 'Zaytoonah Group',
      status: 'confirmed',
      sector: 'Industrial',
      location: 'Sahab Industrial Zone, Amman',
      contractValue: 500000,
      timelineRange: '10 months (Aug 2026 – Jun 2027)',
      bidAmount: 480000,
      projectId: 'TRV-PRJ-51092',
      milestones: 'Foundation – M3, Structure – M7, Handover – M10',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '20% upfront / 60% milestones / 20% completion',
      statusSteps: [
        StatusStepModel(label: 'Bid Submitted', date: 'Jul 10, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Selected by Owner', date: 'Jul 13, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Confirmed', date: 'Jul 15, 2026', state: BidStepState.current),
        StatusStepModel(label: 'Guarantee Applied & Active', state: BidStepState.pending),
        StatusStepModel(label: 'In Progress → Completed', state: BidStepState.pending),
      ],
    ),
    '4': const BidDetailModel(
      id: '4',
      projectTitle: 'Al-Salam Mall',
      companyName: 'Al-Salam Retail Group',
      status: 'inProgress',
      sector: 'Real Estate',
      location: 'Al-Salam, Amman',
      contractValue: 152000,
      timelineRange: '10 months (Jun 2026 – Apr 2027)',
      bidAmount: 152000,
      projectId: 'TRV-PRJ-33871',
      guaranteeExpiresInDays: 7,
      statusSteps: [
        StatusStepModel(label: 'Bid Submitted', date: 'Jun 20, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Selected by Owner', date: 'Jun 24, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Confirmed', date: 'Jun 26, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Guarantee Applied & Active', date: 'Jul 1, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'In Progress', state: BidStepState.current),
        StatusStepModel(label: 'Pending Review → Completed', state: BidStepState.pending),
      ],
    ),
    '5': const BidDetailModel(
      id: '5',
      projectTitle: 'Amman Trade Center',
      companyName: 'Al-Noor Development',
      status: 'guaranteeRejected',
      sector: 'Commercial',
      location: 'Shmeisani, Amman',
      contractValue: 96000,
      timelineRange: '7 months (Aug 2026 – Mar 2027)',
      bidAmount: 96000,
      projectId: 'TRV-PRJ-74530',
      milestones: 'Fit-out – M3, MEP – M5, Handover – M7',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '20% upfront / 60% milestones / 20% completion',
      bannerNote:
          'Al-Noor Development did not accept the issuing bank on this guarantee. Apply again with a different bank or terms.',
      statusSteps: [
        StatusStepModel(label: 'Bid Submitted', date: 'Jun 22, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Selected by Owner', date: 'Jun 27, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Confirmed', date: 'Jun 29, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Guarantee Applied', date: 'Jul 3, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Guarantee Issued by Bank', date: 'Jul 6, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Rejected by Owner', date: 'Jul 9, 2026', state: BidStepState.rejected),
      ],
    ),
    '7': const BidDetailModel(
      id: '7',
      projectTitle: 'Marka Textile Fit-out',
      companyName: 'Marka Retail Holdings',
      status: 'completed',
      sector: 'Renovation & Fit-out',
      location: 'Marka, Amman',
      contractValue: 58000,
      timelineRange: '4 months (Jan 2026 – Apr 2026)',
      bidAmount: 58000,
      projectId: 'TRV-PRJ-22417',
      milestones: 'Demo – M1, Fit-out – M3, Handover – M4',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '25% upfront / 50% milestones / 25% completion',
      reviewRating: 5,
      reviewText:
          'Excellent execution and communication. The team delivered ahead of schedule and the quality exceeded expectations.',
      statusSteps: [
        StatusStepModel(label: 'Bid Submitted', date: 'Dec 15, 2025', state: BidStepState.completed),
        StatusStepModel(label: 'Selected by Owner', date: 'Dec 20, 2025', state: BidStepState.completed),
        StatusStepModel(label: 'Confirmed', date: 'Dec 22, 2025', state: BidStepState.completed),
        StatusStepModel(label: 'Guarantee Applied & Active', date: 'Dec 29, 2025', state: BidStepState.completed),
        StatusStepModel(label: 'In Progress', date: 'Jan 5, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Pending Review', date: 'Apr 20, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Completed', date: 'Apr 24, 2026', state: BidStepState.completed),
      ],
    ),
    '6': const BidDetailModel(
      id: '6',
      projectTitle: 'Al-Noor Tower Construction',
      companyName: 'Al-Noor Development',
      status: 'selected',
      sector: 'Construction',
      location: 'Amman, Abdali District',
      contractValue: 240000,
      timelineRange: '14 months (Aug 2026 – Oct 2027)',
      bidAmount: 240000,
      projectId: 'TRV-PRJ-40218',
      milestones: 'Foundation – M2, Structure – M8, Handover – M14',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '20% upfront / 60% milestones / 20% completion',
      description: '18-floor mixed-use tower in Abdali. Structural, MEP, and finishing works.',
      statusSteps: [
        StatusStepModel(label: 'Bid Submitted', date: 'Jul 5, 2026', state: BidStepState.completed),
        StatusStepModel(label: 'Selected by Owner', date: 'Jul 14, 2026', state: BidStepState.current),
        StatusStepModel(label: 'Confirmed', state: BidStepState.pending),
        StatusStepModel(label: 'Guarantee Applied & Active', state: BidStepState.pending),
        StatusStepModel(label: 'In Progress → Completed', state: BidStepState.pending),
      ],
    ),
  };
}
