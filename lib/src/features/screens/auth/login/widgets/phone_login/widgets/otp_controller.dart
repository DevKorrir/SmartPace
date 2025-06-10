import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/auth/login/widgets/phone_login/widgets/repo/authentication_repository.dart';
import 'package:smart_pace/src/routing/navigation/navigation.dart';


class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  void verifyOTP(String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOtp(otp);
    isVerified ? Get.offAll( MainNavigation()) : Get.back();
  }


}