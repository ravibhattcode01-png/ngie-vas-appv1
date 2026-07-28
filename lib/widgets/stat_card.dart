import 'package:flutter/material.dart';
import '../config.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const StatCard({super.key, required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: valueColor ?? Brand.navy,
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
