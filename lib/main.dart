import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NgieVasApp());
}

class NgieVasApp extends StatelessWidget {
  const NgieVasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..bootstrap(),
      child: MaterialApp(
        title: 'NGiE VAS',
        debugShowCheckedModeBanner: false,
        theme: Brand.theme(),
        home: const _Root(),
      ),
    );
  }
}

class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.loading) {
      return const Scaffold(
        backgroundColor: Brand.navy,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
