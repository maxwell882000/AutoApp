
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Test extends StatefulWidget {

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(android:androidInitilize,iOS:iOSinitilize);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  Future onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return NewScreen(
        payload: payload,
      );
    }));
  }

  // Future _showNotification() async {
  //   var androidDetails = new AndroidNotificationDetails(
  //       "Channel ID", "Desi programmer", "This is my channel",
  //       importance: Importance.high);
  //   var iSODetails = new IOSNotificationDetails();
  //   var generalNotificationDetails =
  //   new NotificationDetails(android: androidDetails, iOS: iSODetails);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //       0, "Task", "You created a Task",
  //       generalNotificationDetails, payload: "Task");
  //
  //
  // }
  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.high);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
    new NotificationDetails(android: androidDetails, iOS: iSODetails);

    // await fltrNotification.show(
    //     0, "Task", "You created a Task", generalNotificationDetails, payload: "Task");
    // tz.initializeTimeZones();
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     0,
    //     'scheduled title',
    //     'scheduled body',
    //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    //     const NotificationDetails(
    //         android: AndroidNotificationDetails('your channel id',
    //             'your channel name', 'your channel description')),
    //     androidAllowWhileIdle: true,
    //     matchDateTimeComponents: DateTimeComponents.time,
    //     uiLocalNotificationDateInterpretation:
    //     UILocalNotificationDateInterpretation.absoluteTime);

  final result =  await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.everyMinute, generalNotificationDetails,
        androidAllowWhileIdle: true);

  }
  showNotification() async {
    var android = AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android:android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
        payload: 'Welcome to the Local Notification demo');
  }
  Future<void> scheduleNotification() async {
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(seconds: 5));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: '@mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android:androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }
  // Future<void> showBigPictureNotification() async {
  //   var bigPictureStyleInformation = BigPictureStyleInformation(
  //     DrawableResourceAndroidBitmap("flutter_devs"),
  //     largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
  //     contentTitle: 'flutter devs',
  //     summaryText: 'summaryText',
  //   );
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'big text channel id',
  //       'big text channel name',
  //       'big text channel description',
  //       styleInformation: bigPictureStyleInformation);
  //   var platformChannelSpecifics =
  //   NotificationDetails(, null);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, 'big text title', 'silent body', platformChannelSpecifics,
  //       payload: "big image notifications");
  // }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        floatingActionButton:RaisedButton(
          onPressed: _showNotification,
          child: new Text('Set Task With Notification'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ],
          ),
        ),
      );
    }
  }

class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    @required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}