import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../widgets/stat_card.dart';
import '../widgets/status_pill.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final d = await ApiClient.instance.get('dashboard');
      if (mounted) setState(() { _data = d; _loading = false; });
      await context.read<AuthProvider>().refresh();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (_loading) return const Center(child: CircularProgressIndicator());

    final recent = (_data?['recent'] as List?) ?? [];
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Hi, ${user?.name ?? ''}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Brand.navy)),
          if (user?.companyName != null)
            Text(user!.companyName!, style: const TextStyle(color: Color(0xFF64748B))),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: StatCard(label: 'Wallet Balance', value: '₹${_data?['balance'] ?? '0.00'}')),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Sent (month)', value: '${_data?['month_sent'] ?? 0}')),
          ]),
          const SizedBox(height: 12),
          StatCard(
            label: 'Delivery Rate',
            value: '${_data?['delivery_rate'] ?? 0}%',
            valueColor: Brand.teal,
          ),
          const SizedBox(height: 20),
          const Text('Recent Campaigns',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Brand.navy)),
          const SizedBox(height: 8),
          if (recent.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(child: Text('No campaigns yet.', style: TextStyle(color: Color(0xFF94A3B8)))),
            ),
          ...recent.map((c) => Card(
                child: ListTile(
                  title: Text(c['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${(c['channel'] ?? '').toString().toUpperCase()} · ${c['total_recipients']} recipients'),
                  trailing: StatusPill(c['status'] ?? ''),
                ),
              )),
        ],
      ),
    );
  }
}
