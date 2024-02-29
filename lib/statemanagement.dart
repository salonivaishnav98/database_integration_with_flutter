import 'package:get/get.dart';

class UserAuth extends GetxController{
  var passVisibility = true.obs;
  void passAuth(){
    passVisibility.value = ! passVisibility.value;
  }
}