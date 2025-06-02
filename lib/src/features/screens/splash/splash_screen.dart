import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/constants/colors.dart';
import 'package:smart_pace/src/constants/image_string.dart';
import 'package:smart_pace/src/constants/sizes.dart';
import 'package:smart_pace/src/constants/text_string.dart';
import 'package:smart_pace/src/features/authentication/controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashScreenController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashScreenController.startAnimation();
    final size = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Stack(
          children: [
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 1600),
                top: 0,
                left: splashScreenController.animate.value ? 0 : -30,
                child: Image(
                  height: 100,
                  width: 100,
                  image: AssetImage(tSplashTopIcon),
                ),
              ),
            ),

            Obx(
              () => AnimatedPositioned(
                duration: Duration(milliseconds: 1600),
                top: 80,
                left:
                    splashScreenController.animate.value ? tDefaultSize : -100,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 1600),
                  opacity: splashScreenController.animate.value ? 1 : 0,
                  child: Column(
                    children: [
                      Text(
                        tAppName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        tAppTagline,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => AnimatedPositioned(
                duration: Duration(milliseconds: 2400),
                left: 0,
                right: 40,
                bottom: splashScreenController.animate.value ? size*0.25 : 0,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 2000),
                  opacity: splashScreenController.animate.value ? 1 : 0,
                  child: Image(image: AssetImage(tSplashImage)),
                ),
              ),
            ),
            Obx(
              () => AnimatedPositioned(
                duration: Duration(milliseconds: 2400),
                bottom: splashScreenController.animate.value ? 40 : 0,
                right: 10,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 2400),
                  opacity: splashScreenController.animate.value ? 1 : 0,
                  child: Container(
                    height: tDefaultContainerSize,
                    width: tDefaultContainerSize,
                    decoration: BoxDecoration(
                      color: tPrimaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
