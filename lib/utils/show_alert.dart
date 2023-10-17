import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

void displayDialog(BuildContext context, String title, String content,
    IconData icon, Color color) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 5,
        title: Text(title),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(content),
            const SizedBox(
              height: 10,
            ),
            Icon(
              icon,
              size: 85,
              color: color,
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
                style: TextButton.styleFrom(
                  fixedSize: const Size(100, 50),
                  textStyle: const TextStyle(fontSize: 20, color: Colors.white),
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ok')),
          )
        ],
      );
    },
  );
}

ScaffoldFeatureController showBottomAlert(
    {required BuildContext context, required String message, Color? color}) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
    backgroundColor: color ?? Colors.red,
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


Future<bool> showAlertDelete(BuildContext context) {
  Completer<bool> completer = Completer<bool>();
  
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      completer.complete(false);
      Navigator.pop(context);
    },
  );

  Widget continueButton = TextButton(
    child: const Text("Eliminar"),
    onPressed: () {
      FocusScope.of(context).unfocus();
      completer.complete(true);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Eliminar Campo"),
    content: const Text("Está de acuerdo en eliminar este información?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return completer.future;
}

 // Configure local notifications

Future<void> showNotification(String message,FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'channel_description',
            importance: Importance.max,
            priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'FindMe', message, platformChannelSpecifics);
  }