import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_pace/src/constants/sizes.dart';
import 'package:smart_pace/src/constants/text_string.dart';

import '../../../constants/colors.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tOtpTitle,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 100,
              ),
            ),
            Text(
              tOtpSubtitle.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 40.0,),
            const Text("$tOtpMessage support911@gmail.com", textAlign: TextAlign.center, style: TextStyle(fontSize: 16),),
            const SizedBox(height: tDefaultSize,),
            OtpTextField(
               numberOfFields: 6,
              fillColor: Colors.black.withOpacity(0.1),
              filled: true,
            ),
            const SizedBox(height: tDefaultSize,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: tWhiteColor,
                  backgroundColor: tSecondaryColor,
                  side: BorderSide(color: tSecondaryColor),
                  padding: EdgeInsets.symmetric(
                    vertical: tButtonHeight,
                  ),
                ),
                child: Text(tNext.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
