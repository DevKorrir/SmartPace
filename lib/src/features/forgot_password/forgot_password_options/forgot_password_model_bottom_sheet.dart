import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/forgot_password/forgot_password_mail/forgot_password_mail.dart';
import 'package:smart_pace/src/features/forgot_password/forgot_password_phone/forgot_password_phone.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_string.dart';
import 'forgot_password_btn_widget.dart';

class ForgotPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tForgotPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  tForgotPasswordSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: tDefaultSize),
                ForgotPasswordWidget(
                  btnIcon: Icons.email_outlined,
                  title: tEmail,
                  subTitle: tResetViaEmail,
                  onTap: () {
                    Get.to(() => ForgotPasswordMailScreen());
                  },
                ),
                const SizedBox(height: 20.0),
                ForgotPasswordWidget(
                  btnIcon: Icons.mobile_friendly,
                  title: tPhoneNo,
                  subTitle: tResetViaPhone,
                  onTap: () {Get.to(ForgotPasswordPhoneScreen());},
                ),
              ],
            ),
          ),
    );
  }
}
