import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/common_widgets/forgot_password/form_header_widget.dart';
import 'package:smart_pace/src/constants/image_string.dart';
import 'package:smart_pace/src/constants/sizes.dart';
import 'package:smart_pace/src/constants/text_string.dart';
import 'package:smart_pace/src/features/forgot_password/forgot_password_otp/otp_screen.dart';

import '../../../constants/colors.dart';

class ForgotPasswordMailScreen extends StatelessWidget {
  const ForgotPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(tDefaultSize),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 3),
                FormHeaderWidget(
                  image: tForgotImage,
                  title: tForgotPassword,
                  subTitle: tForgotMailSubtitle,
                  heightBetween: tDefaultSize,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          label: Text(tEmail),
                          hintText: tEmail,
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {Get.to(()=> OtpScreen());},
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
        ),
      ),
    );
  }
}
