import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/constants/text_string.dart';
import 'package:smart_pace/src/features/screens/auth/login.dart';

import '../../../constants/colors.dart';
import '../../../constants/image_string.dart';
import '../../../constants/sizes.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage(tWelcomeScreenImage),
                  height: size.height * 0.25,
                ),
                Text(
                  tSignUpTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  tSignUpnSubtitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                Form(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: tFormHeight - 10.0,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_2_outlined),
                            labelText: tFullName,
                            hintText: tFullName,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: tFormHeight - 20.0),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: tEmail,
                            hintText: tEmail,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: tFormHeight - 20.0),

                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            labelText: tPhoneNo,
                            hintText: tPhoneNo,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: tFormHeight - 20.0),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            labelText: tPassword,
                            hintText: tPassword,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: tFormHeight),

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
                            child: Text(tSignup.toUpperCase()),
                          ),
                        ),
                        const SizedBox(height: tFormHeight -18),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("OR"),
                            const SizedBox(height: tFormHeight - 18.0),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: Image(
                                  image: AssetImage(tGoogleLogoImage),
                                  width: 20.0,
                                ),
                                onPressed: () {},
                                label: Text(tSignInWithGoogle),
                              ),
                            ),
                            const SizedBox(height: tFormHeight),
                            TextButton(
                              onPressed: () => Get.to(()=>Login()),
                              child: Text.rich(
                                TextSpan(
                                  text: tAlreadyHaveAnAccount,style: Theme.of(context).textTheme.bodyLarge,
                                  children: [TextSpan(text: tLogin.toUpperCase(),style: TextStyle(color: Colors.purple))],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}
