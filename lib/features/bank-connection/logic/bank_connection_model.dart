// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/bank-connection/available-banks
// [ { "code": "AB", "name": "Arab Bank" }, { "code": "HB", "name": "Housing Bank" }, ... ]
//
// POST /api/bank-connection/authorize
// { "bankCode": "AB" }
// → kicks off the Open Finance redirect/consent flow server-side; the
//   consent bullets shown in the modal ("Account balances & assets",
//   "Existing debt & repayment history", "Transaction history") are the
//   scopes being requested — surface them from the backend too if they
//   ever become bank-specific rather than hardcoding in the widget.
// ───────────────────────────────────────────────────────────────────────

class BankOption {
  final String code; // e.g. "AB"
  final String name;
  const BankOption({required this.code, required this.name});

  factory BankOption.fromJson(Map<String, dynamic> json) =>
      BankOption(code: json['code'] as String, name: json['name'] as String);

  static List<BankOption> demoList() => const [
        BankOption(code: 'AB', name: 'Arab Bank'),
        BankOption(code: 'HB', name: 'Housing Bank'),
        BankOption(code: 'CA', name: 'Cairo Amman Bank'),
      ];
}
