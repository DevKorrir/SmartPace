import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackEmailButton extends StatelessWidget {
  const BackEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Get.back(),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Prefer email login? ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          children: const [
            TextSpan(
              text: 'Go back',
              style: TextStyle(
                color: Color(0xFF34A853),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
