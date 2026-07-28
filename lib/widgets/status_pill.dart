import 'package:flutter/material.dart';
import '../config.dart';

class StatusPill extends StatelessWidget {
  final String status;
  const StatusPill(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final s = status.toLowerCase();
    Color bg, fg;
    if (['completed', 'delivered', 'active', 'paid'].contains(s)) {
      bg = Brand.teal.withOpacity(0.12);
      fg = Brand.teal;
    } else if (['processing', 'queued', 'pending', 'partial', 'sent'].contains(s)) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFB45309);
    } else if (['failed', 'suspended'].contains(s)) {
      bg = const Color(0xFFFEE2E2);
      fg = const Color(0xFFB91C1C);
    } else {
      bg = const Color(0xFFF1F5F9);
      fg = const Color(0xFF475569);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
