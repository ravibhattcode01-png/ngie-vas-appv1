import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _busy = true; _error = null; });
    try {
      await context.read<AuthProvider>().login(_email.text.trim(), _password.text);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Brand.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Row(children: [
                  const Text('NGiE ',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('VAS', style: TextStyle(color: Brand.gold, fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
                const SizedBox(height: 6),
                const Text('Bulk SMS · WhatsApp · IVR',
                    style: TextStyle(color: Colors.white54, fontSize: 13)),
                const SizedBox(height: 40),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Welcome back',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Brand.navy)),
                          const SizedBox(height: 4),
                          const Text('Sign in to your account',
                              style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                          const SizedBox(height: 20),
                          if (_error != null)
                            Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(_error!,
                                  style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 13)),
                            ),
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'Email'),
                            validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password'),
                            validator: (v) => (v == null || v.isEmpty) ? 'Enter your password' : null,
                          ),
                          const SizedBox(height: 22),
                          ElevatedButton(
                            onPressed: _busy ? null : _submit,
                            child: _busy
                                ? const SizedBox(
                                    height: 20, width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Sign in'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text('Nextgen Infotech Enterprises · Lucknow',
                      style: TextStyle(color: Colors.white38, fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
