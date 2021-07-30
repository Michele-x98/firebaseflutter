import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:notification_permissions/notification_permissions.dart';

class NotificationSettingsPage extends StatefulWidget {
  NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage>
    with WidgetsBindingObserver {
  bool _permissionStatus = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _fetchPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('app resumed');
      setState(() {});
    }
  }

  Future<PermissionStatus> _fetchPermission() =>
      NotificationPermissions.getNotificationPermissionStatus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PermissionStatus>(
        future: _fetchPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == PermissionStatus.granted) {
              _permissionStatus = true;
            } else {
              _permissionStatus = false;
            }
            return Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      snapshot.data.toString(),
                    ),
                    Switch(
                      value: _permissionStatus,
                      onChanged: (bool value) {
                        if (_permissionStatus) {
                          AppSettings.openAppSettings();
                        } else {
                          NotificationPermissions
                              .requestNotificationPermissions(
                            openSettings: true,
                          );
                        }
                      },
                    )
                    // : TextButton(
                    //     onPressed: () => NotificationPermissions
                    //         .requestNotificationPermissions(
                    //       openSettings: true,
                    //     ),
                    //     child: Text('Enable notification'),
                    //   )
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
