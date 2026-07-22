// guarantee_submitted_screen.dart
import 'package:flutter/material.dart';
import 'package:trova/core/routes.dart';

class GuaranteeSubmittedScreen extends StatelessWidget {
  const GuaranteeSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guarantee Submitted (Pending)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_bottom, size: 32, color: Colors.amber),
              ),
              const SizedBox(height: 24),
              const Text(
                'Submitted to Bank',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your guarantee application is pending bank review. You'll be notified once it's issued.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.homeDashboard,
                      (route) => false,
                    );
                  },
                  child: const Text('Back to Dashboard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}