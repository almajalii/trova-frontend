// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/bank-connection/banks
// [ { "code": "AB", "name": "Arab Bank" }, { "code": "HB", "name": "Housing Bank" }, ... ]
//
// POST /api/bank-connection/connect
// { "bankCode": "AB", "remainingDebtCapacityJod": 5000.0, "numberOfDelinquentDebts": 0 }
// → kicks off the Open Finance redirect/consent flow server-side; the
//   consent bullets shown in the modal ("Account balances & assets",
//   "Existing debt & repayment history", "Transaction history") are the
//   scopes being requested — surface them from the backend too if they
//   ever become bank-specific rather than hardcoding in the widget.
// Response 200: { "data": { "bankName": "Arab Bank" } } — the authoritative
//   bank name to show on the "Bank Connected" screen, not the locally
//   selected BankOption.name.
// ───────────────────────────────────────────────────────────────────────

class BankOption {
  final String code; // e.g. "AB"
  final String name;
  const BankOption({required this.code, required this.name});

  factory BankOption.fromJson(Map<String, dynamic> json) =>
      BankOption(code: json['code'] as String, name: json['name'] as String);

  /// First letter of each word in [name], capitalized (e.g. "Arab Bank" -> "AB").
  String get initials {
    final words = name.trim().split(RegExp(r'\s+'));
    return words.map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
  }
}
