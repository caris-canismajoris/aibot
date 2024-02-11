import 'package:aibot/config.dart';

class NotificationController extends GetxController {
  List notificationLists = [];

  @override
  void onReady() {
    notificationLists = appArray.notificationList;
    update();
    // TODO: implement onReady
    super.onReady();
  }
}
