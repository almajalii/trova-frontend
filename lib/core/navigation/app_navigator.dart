import 'package:flutter/material.dart';
import 'package:trova/core/routes.dart';

/// App-wide navigator key so code with no BuildContext of its own — like the
/// DioClient error interceptor — can still trigger navigation, e.g. to
/// redirect to the account-approval status screen the moment a 403 comes
/// back for that reason, regardless of which screen/bloc made the call.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

/// Redirects to the pending/rejected account-status screen, wiping the
/// stack underneath it so the user can't navigate "back" into a screen that
/// will just 403 again. Called from DioClient's error interceptor as soon as
/// any request comes back 403 with an `approvalStatus` body, regardless of
/// which feature/screen made the call.
void redirectForAccountApproval(String approvalStatus, String? rejectionReason) {
  final navigator = appNavigatorKey.currentState;
  if (navigator == null) return;

  final targetRoute = approvalStatus == 'rejected' ? AppRoutes.accountRejected : AppRoutes.accountPending;
  if (ModalRoute.of(navigator.context)?.settings.name == targetRoute) {
    return; // already there — don't stack a duplicate
  }

  navigator.pushNamedAndRemoveUntil(targetRoute, (route) => false, arguments: rejectionReason);
}
