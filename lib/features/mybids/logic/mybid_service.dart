import 'package:trova/features/mybids/logic/mybid_model.dart';

/// Mock implementation for now — no Dio dependency yet.
/// TODO(backend): swap internals for real .NET Web API calls once the
/// bids/guarantees endpoints exist. Keep method signatures the same so
/// the bloc doesn't need to change.
class BidsService {
  static final List<BidModel> _mockBids = [
    const BidModel(
      id: '1',
      projectTitle: 'Al-Noor Tower Construction',
      companyName: 'Al-Noor Development',
      bidAmount: 238000,
      status: 'pending',
      note: 'Awaiting owner review',
    ),
    const BidModel(
      id: '2',
      projectTitle: 'Downtown Office Renovation',
      companyName: 'Zaytoonah Group',
      bidAmount: 82000,
      status: 'selected',
      note: "You've been selected for this project. Confirm to accept and move forward.",
    ),
    const BidModel(
      id: '3',
      projectTitle: 'Zaytoonah Business Park',
      companyName: 'Zaytoonah Group',
      bidAmount: 480000,
      status: 'confirmed',
      note: 'Confirmed on July 15, 2026. Apply for your bank guarantee to move this project forward.',
    ),
    const BidModel(
      id: '4',
      projectTitle: 'Al-Salam Mall',
      companyName: 'Al-Salam Retail Group',
      bidAmount: 152000,
      status: 'inProgress',
      note: 'Your Guarantee: Active',
      guaranteeExpiresInDays: 7,
    ),
    const BidModel(
      id: '5',
      projectTitle: 'Amman Trade Center',
      companyName: 'Al-Noor Development',
      bidAmount: 96000,
      status: 'guaranteeRejected',
      note: 'The owner rejected your guarantee application. Apply for a new one or back off.',
    ),
  ];

  Future<List<BidModel>> fetchBids() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_mockBids);
  }

  Future<List<BidModel>> confirmBid(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _updateStatus(
      id,
      status: 'confirmed',
      note: 'Confirmed. Apply for your bank guarantee to move this project forward.',
    );
    return fetchBids();
  }

  Future<List<BidModel>> cancelBid(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockBids.removeWhere((b) => b.id == id);
    return fetchBids();
  }

  Future<List<BidModel>> applyForGuarantee(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _updateStatus(
      id,
      status: 'inProgress',
      note: 'Your Guarantee: Active',
      guaranteeExpiresInDays: 30,
    );
    return fetchBids();
  }

  Future<List<BidModel>> markWorkAsDone(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockBids.removeWhere((b) => b.id == id);
    return fetchBids();
  }

  Future<List<BidModel>> backOff(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockBids.removeWhere((b) => b.id == id);
    return fetchBids();
  }

  Future<List<BidModel>> applyForNewGuarantee(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _updateStatus(
      id,
      status: 'confirmed',
      note: 'Applying for a new bank guarantee.',
    );
    return fetchBids();
  }

  void _updateStatus(
    String id, {
    required String status,
    required String note,
    int? guaranteeExpiresInDays,
  }) {
    final index = _mockBids.indexWhere((b) => b.id == id);
    if (index == -1) return;
    final old = _mockBids[index];
    _mockBids[index] = BidModel(
      id: old.id,
      projectTitle: old.projectTitle,
      companyName: old.companyName,
      bidAmount: old.bidAmount,
      status: status,
      note: note,
      guaranteeExpiresInDays: guaranteeExpiresInDays,
    );
  }
}