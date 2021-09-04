import 'package:app_settings/app_settings.dart';
import 'package:firebaseflutter/controller/notificationX_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_permissions/notification_permissions.dart';

class NotificationSettingsPage extends StatefulWidget {
  NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      Get.find<NotificationXController>().updatePermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    NotificationXController nx = Get.put(NotificationXController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings Page'),
      ),
      body: Obx(
        () => ListView(
          children: [
            FutureBuilder<PermissionStatus>(
              future: nx.fetchPermission(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == PermissionStatus.granted) {
                    nx.permissionStatus.value = true;
                  } else {
                    nx.permissionStatus.value = false;
                  }
                  return Container(
                    child: Center(
                      child: Obx(
                        () => ListTile(
                          title: Text('Notification Permission'),
                          trailing: CupertinoSwitch(
                            value: nx.permissionStatus.value,
                            onChanged: (bool value) {
                              if (nx.permissionStatus.value) {
                                AppSettings.openAppSettings();
                              } else {
                                NotificationPermissions
                                    .requestNotificationPermissions(
                                  openSettings: true,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            ListTile(
              title: Text('Send notification'),
              trailing: ElevatedButton(
                onPressed: !nx.permissionStatus.value ? null : () => {},
                child: Text('SEND'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
