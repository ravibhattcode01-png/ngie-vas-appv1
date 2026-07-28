import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../config.dart';
import '../models/ledger.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Razorpay _razorpay;
  List<LedgerEntry> _ledger = [];
  bool _loading = true;
  int _amount = 2000;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _load();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final d = await ApiClient.instance.get('wallet/ledger');
      final list = (d['data'] as List).map((e) => LedgerEntry.fromJson(e)).toList();
      if (mounted) setState(() { _ledger = list; _loading = false; });
      await context.read<AuthProvider>().refresh();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _startRecharge() async {
    try {
      final order = await ApiClient.instance.post('wallet/recharge', {'amount': _amount});
      _razorpay.open({
        'key': order['key_id'],
        'amount': order['amount'],
        'order_id': order['order_id'],
        'name': 'NGiE VAS',
        'description': 'Wallet recharge',
        'theme': {'color': '#0E7C7B'},
      });
    } catch (e) {
      _snack(e.toString());
    }
  }

  void _onPaymentSuccess(PaymentSuccessResponse r) {
    // Wallet is credited server-side via the verified webhook; just refresh.
    _snack('Payment received. Wallet will update shortly.');
    Future.delayed(const Duration(seconds: 2), _load);
  }

  void _onPaymentError(PaymentFailureResponse r) => _snack('Payment failed or cancelled.');

  void _snack(String m) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Balance', style: TextStyle(color: Color(0xFF64748B))),
                  const SizedBox(height: 6),
                  Text('₹${user?.balance ?? '0.00'}',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Brand.navy)),
                  const SizedBox(height: 18),
                  Row(
                    children: [500, 2000, 5000].map((p) {
                      final active = _amount == p;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: active ? Brand.teal.withOpacity(0.08) : null,
                              side: BorderSide(color: active ? Brand.teal : const Color(0xFFCBD5E1)),
                            ),
                            onPressed: () => setState(() => _amount = p),
                            child: Text('₹$p',
                                style: TextStyle(color: active ? Brand.teal : Brand.ink, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(onPressed: _startRecharge, child: Text('Recharge ₹$_amount')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Transaction History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Brand.navy)),
          const SizedBox(height: 8),
          if (_loading) const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator())),
          ..._ledger.map((l) {
            final credit = l.type == 'CREDIT';
            return Card(
              child: ListTile(
                dense: true,
                title: Text(l.source, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(l.createdAt.length >= 10 ? l.createdAt.substring(0, 10) : l.createdAt),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${credit ? '+' : '−'}₹${l.amount}',
                        style: TextStyle(
                            color: credit ? Brand.teal : const Color(0xFFB91C1C), fontWeight: FontWeight.bold)),
                    Text('₹${l.balanceAfter}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
