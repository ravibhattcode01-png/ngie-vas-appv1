import 'package:flutter/material.dart';
import '../config.dart';
import '../models/campaign.dart';
import '../services/api_client.dart';
import '../widgets/status_pill.dart';
import 'campaign_create_screen.dart';
import 'campaign_detail_screen.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});
  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  List<Campaign> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final d = await ApiClient.instance.get('campaigns');
      final list = (d['data'] as List).map((e) => Campaign.fromJson(e)).toList();
      if (mounted) setState(() { _items = list; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Brand.mist,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Brand.teal,
        icon: const Icon(Icons.add),
        label: const Text('New'),
        onPressed: () async {
          final created = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => const CampaignCreateScreen()));
          if (created == true) _load();
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _items.isEmpty
                  ? ListView(children: const [
                      SizedBox(height: 120),
                      Center(child: Text('No campaigns yet.', style: TextStyle(color: Color(0xFF94A3B8)))),
                    ])
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _items.length,
                      itemBuilder: (_, i) {
                        final c = _items[i];
                        return Card(
                          child: ListTile(
                            title: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(
                                '${c.channel.toUpperCase()} · ${c.sentCount}/${c.totalRecipients} sent · ₹${c.totalCost}'),
                            trailing: StatusPill(c.status),
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => CampaignDetailScreen(campaignId: c.id))),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
