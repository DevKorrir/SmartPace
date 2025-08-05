import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFAQItem(
              'How do I create a study plan?',
              'Go to the Plan tab and tap the "+" button to create a new study plan.',
            ),
            _buildFAQItem(
              'How do I join a study group?',
              'Navigate to the Groups tab and browse available groups or create your own.',
            ),
            _buildFAQItem(
              'How do I change my profile information?',
              'Use the dropdown menu (three dots) and select Account to edit your profile.',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'Contact Support',
                  'Support feature coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('Contact Support'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}
