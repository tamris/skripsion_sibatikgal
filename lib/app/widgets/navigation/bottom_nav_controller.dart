import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;
  
  void changePage(int index) {
    currentIndex.value = index;
  }
  
  // Optional: untuk set page dari luar
  void setPage(int index) {
    currentIndex.value = index;
  }
}