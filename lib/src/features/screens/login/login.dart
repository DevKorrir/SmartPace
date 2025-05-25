import 'package:flutter/material.dart';
import 'package:smart_pace/src/constants/image_string.dart';
import 'package:smart_pace/src/constants/sizes.dart';
import 'package:smart_pace/src/constants/text_string.dart';

import '../../../constants/colors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                tLoginTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                tLoginSubtitle,
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
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.visibility),
                          ),
                          labelText: tPassword,
                          hintText: tPassword,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: tFormHeight - 25),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(tForgotPassword),
                        ),
                      ),
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
                          child: Text(tLogin.toUpperCase()),
                        ),
                      ),
                      const SizedBox(height: tFormHeight - 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("OR"),
                          const SizedBox(height: tFormHeight - 10.0),
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
                            onPressed: () {},
                            child: Text.rich(
                              TextSpan(
                                text: tDontHaveAnAccount,style: Theme.of(context).textTheme.bodyLarge,
                                children: [TextSpan(text: tSignup,style: TextStyle(color: Colors.purple))],
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
