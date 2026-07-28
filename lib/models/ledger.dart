class LedgerEntry {
  final int id;
  final String type;
  final String amount;
  final String balanceAfter;
  final String source;
  final String createdAt;

  LedgerEntry({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.source,
    required this.createdAt,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> j) => LedgerEntry(
        id: j['id'],
        type: j['type'] ?? 'CREDIT',
        amount: (j['amount'] ?? '0.00').toString(),
        balanceAfter: (j['balance_after'] ?? '0.00').toString(),
        source: j['source'] ?? '',
        createdAt: j['created_at'] ?? '',
      );
}
