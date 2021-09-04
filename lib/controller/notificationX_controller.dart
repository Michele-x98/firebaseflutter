import 'package:get/get.dart';
import 'package:notification_permissions/notification_permissions.dart';

class NotificationXController extends GetxController {
  Future<PermissionStatus> fetchPermission() =>
      NotificationPermissions.getNotificationPermissionStatus();

  var permissionStatus = false.obs;

  updatePermissionStatus() async {
    await fetchPermission().then((value) {
      if (value == PermissionStatus.granted) {
        permissionStatus.value = true;
        return;
      }
      permissionStatus.value = false;
    });
  }

  sendNotification() async {}
}
