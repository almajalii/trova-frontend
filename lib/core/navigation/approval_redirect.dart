import 'package:flutter/material.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/models/user_model.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/core/routes.dart';
import 'package:trova/features/company-details/logic/company_details_service.dart';
import 'package:trova/features/company-details/presentation/screens/company_details_screen.dart';

/// Routes to Home Dashboard / Account Pending / Account Rejected based on a
/// freshly-fetched user's `approvalStatus`. Accounts start "pending" and
/// most endpoints 403 until an admin approves them, so this replaces the
/// unconditional "go to dashboard" navigation right after signup (once bank
/// connection finishes) and right after login/biometric unlock.
Future<void> navigateByApprovalStatus(BuildContext context, UserModel user) async {
  if (user.isRejected) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.accountRejected, (route) => false, arguments: user.rejectionReason);
    return;
  }
  if (user.isPending) {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.accountPending, (route) => false);
    return;
  }

  // Approved doesn't mean onboarding is finished — approval can land before
  // company details/bank connection ever happen (e.g. a user who registered,
  // left mid-onboarding, and got approved before coming back). Resume at
  // Company Details rather than assuming it's done and dropping them
  // straight on the dashboard; CompanyDetailsScreen's own default onSaved
  // already chains into Connect Bank -> Bank Connected -> back here.
  var hasCompanyDetails = true;
  try {
    await sl<CompanyDetailsService>().fetchMyCompanyDetails();
  } on ApiException catch (e) {
    if (e.isNotFound) hasCompanyDetails = false;
    // Any other error (network blip, etc.) — fail open and assume it's
    // done rather than stranding an already-approved user.
  }
  if (!context.mounted) return;

  if (!hasCompanyDetails) {
    Navigator.of(
      context,
    ).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const CompanyDetailsScreen()), (route) => false);
    return;
  }
  Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.homeDashboard, (route) => false);
}
