import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../models/template.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';

class CampaignCreateScreen extends StatefulWidget {
  const CampaignCreateScreen({super.key});
  @override
  State<CampaignCreateScreen> createState() => _CampaignCreateScreenState();
}

class _CampaignCreateScreenState extends State<CampaignCreateScreen> {
  final _title = TextEditingController();
  final _recipients = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<MessageTemplate> _templates = [];
  MessageTemplate? _selected;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
    _recipients.addListener(() => setState(() {}));
  }

  Future<void> _loadTemplates() async {
    try {
      final d = await ApiClient.instance.get('templates');
      setState(() => _templates = (d['data'] as List).map((e) => MessageTemplate.fromJson(e)).toList());
    } catch (_) {}
  }

  int get _recipientCount =>
      _recipients.text.split(RegExp(r'[\s,]+')).where((s) => s.trim().isNotEmpty).length;

  double get _cost {
    final user = context.read<AuthProvider>().user;
    if (user == null || _selected == null) return 0;
    return _recipientCount * user.rateFor(_selected!.channel) / 100;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selected == null) {
      setState(() => _error = 'Select a template and add recipients.');
      return;
    }
    setState(() { _busy = true; _error = null; });
    try {
      await ApiClient.instance.post('campaigns', {
        'title': _title.text.trim(),
        'template_id': _selected!.id,
        'recipients': _recipients.text,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Campaign')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)),
                  child: Text(_error!, style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 13)),
                ),
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Campaign Title'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter a title' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<MessageTemplate>(
                value: _selected,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'DLT Template'),
                items: _templates
                    .map((t) => DropdownMenuItem(
                        value: t, child: Text('[${t.channel.toUpperCase()}] ${t.name}', overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (t) => setState(() => _selected = t),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _recipients,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Recipients',
                  hintText: '9876543210\n9812345678',
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Add at least one recipient' : null,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Brand.mist, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recipients: $_recipientCount',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Brand.navy)),
                    Text('Est. cost: ₹${_cost.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Brand.teal)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _busy ? null : _submit,
                child: _busy
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Send Campaign'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
