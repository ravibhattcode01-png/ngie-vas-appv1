import 'package:flutter/material.dart';
import '../config.dart';
import '../models/campaign.dart';
import '../services/api_client.dart';
import '../widgets/status_pill.dart';

class CampaignDetailScreen extends StatefulWidget {
  final int campaignId;
  const CampaignDetailScreen({super.key, required this.campaignId});
  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  Campaign? _campaign;
  List<CampaignMessage> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await ApiClient.instance.get('campaigns/${widget.campaignId}');
      final data = d['data'];
      if (mounted) {
        setState(() {
          _campaign = Campaign.fromJson(data);
          _messages = ((data['messages'] as List?) ?? []).map((e) => CampaignMessage.fromJson(e)).toList();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _stat(String label, String value, {Color? color}) => Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color ?? Brand.navy)),
                const SizedBox(height: 2),
                Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_campaign?.title ?? 'Campaign')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(children: [
                  _stat('Recipients', '${_campaign?.totalRecipients ?? 0}'),
                  const SizedBox(width: 8),
                  _stat('Sent', '${_campaign?.sentCount ?? 0}'),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  _stat('Delivered', '${_campaign?.deliveredCount ?? 0}', color: Brand.teal),
                  const SizedBox(width: 8),
                  _stat('Failed', '${_campaign?.failedCount ?? 0}', color: const Color(0xFFB91C1C)),
                ]),
                const SizedBox(height: 16),
                const Text('Per-recipient status',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Brand.navy)),
                const SizedBox(height: 8),
                ..._messages.map((m) => Card(
                      child: ListTile(
                        dense: true,
                        title: Text(m.recipient, style: const TextStyle(fontFamily: 'monospace')),
                        subtitle: m.failureReason != null ? Text(m.failureReason!) : null,
                        trailing: StatusPill(m.status),
                      ),
                    )),
              ],
            ),
    );
  }
}
