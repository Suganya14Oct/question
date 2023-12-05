import 'package:get/get.dart';



class ButtonController extends GetxController {

  String? _type = 'yes';
  String? get type => _type;

  void setType(String type){
    _type = type;
    update();
  }

}