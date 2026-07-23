import 'package:dio/dio.dart';

/// Key checked by DioClient's global `onError` interceptor (see
/// dio_client.dart) — a request carrying this in its `Options.extra` is
/// exempt from the automatic account-approval redirect.
const String kSuppressApprovalRedirectKey = 'suppressApprovalRedirect';

/// Pass as a request's `options:` to opt it out of the global
/// account-approval redirect. Use this for calls made during onboarding —
/// before company details/bank connection are ever submitted — where a
/// still-"pending" account 403ing is expected and already handled locally
/// by the calling screen (e.g. an empty bank list with a retry), rather than
/// letting the global redirect hijack the onboarding flow and dump the user
/// on the Pending Approval screen mid-signup.
final Options suppressApprovalRedirectOptions = Options(extra: {kSuppressApprovalRedirectKey: true});
