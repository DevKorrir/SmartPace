import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/constants/colors.dart';
import 'package:smart_pace/src/features/screens/auth/sign_up.dart';
import 'package:smart_pace/src/features/screens/auth/login.dart';

import '../../../constants/sizes.dart';
import '../../../constants/text_string.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: AssetImage("assets/images/welcome.png"),
                height: height * 0.5,
              ),
              Column(
                children: [
                  Text(
                    tWelcomeTitle,
                    style: TextStyle(fontSize: tDefaultSize, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    tWelcomeSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.offAll(() => Login()),
                      style:  OutlinedButton.styleFrom(
                          foregroundColor: tSecondaryColor,
                          side: BorderSide(color: tSecondaryColor),
                          padding: EdgeInsets.symmetric(vertical: tButtonHeight)
                      ),
                      child: Text(tLogin.toUpperCase()),

                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.offAll(SignUp()),
                      style:  ElevatedButton.styleFrom(
                          foregroundColor: tWhiteColor,
                          backgroundColor: tSecondaryColor,
                          side: BorderSide(color: tSecondaryColor),
                          padding: EdgeInsets.symmetric(vertical: tButtonHeight)
                      ),
                      child: Text(tSignup.toUpperCase()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
