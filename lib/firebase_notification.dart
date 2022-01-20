import 'index.dart';
import 'package:http/http.dart' as http;

class FirebaseNotificationService {
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  FirebaseMessaging _firebaseMessaging;
  var _token;

  initialization() async {
    var rng = new Random();
    _firebaseMessaging = FirebaseMessaging.instance;
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings("notification_icon"),
            iOS: IOSInitializationSettings()), onSelectNotification: (message) {
      if (message != null) {
        try {
          var decoded = json.decode(message);
          redirection(
              navigatorKey.currentContext, json.decode(decoded['content']));
        } catch (e) {
          print("Error is==$e");
        }
      }
      return Future.value(true);
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(sound: true, alert: true);
    FirebaseMessaging.instance.getToken().then((value) {
      _token = value;
    });
    FirebaseMessaging.onMessage.listen((event) {
      if (Platform.isAndroid == true)
        flutterLocalNotificationsPlugin.show(
            rng.nextInt(1000),
            event.notification?.title,
            event.notification?.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
            )),
            payload: json.encode(event.data));
    });
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      var newBody = {
        "registration_ids": [_token],
        "data": {
          "content": {
            "id": 1,
            "channelKey": "basic_channel",
            "title": "Notification Title!",
            "body": "This notification was created via FCM!",
            "payload": {"aj": "vj"},
            "showWhen": true,
            "autoCancel": true,
            "privacy": "Private"
          }
        },
        'notification': {
          'title': 'Notification Title!',
          'body': 'This notification was created via FCM!',
        },
      };
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'
            // 'https://api.rnfirebase.io/messaging/send'
            ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Server Key"
        },
        body: jsonEncode(newBody),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<Null> processInitialNotification(BuildContext context) async {
    try {
      var message = await _firebaseMessaging.getInitialMessage();

      if (message != null) {
        redirection(context, json.decode(message.data['content']));
      }
    } on Exception catch (e) {
      // log("error $e");
    }
  }

  Future<Null> processInitialLocalNotification(BuildContext context) async {
    await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((message) {
      if (message.payload != null) {
        try {

          var decoded = json.decode(message.payload);
          redirection(context, json.decode(decoded['content']));
        } catch (e) {
          print("Error is==$e");
        }
      }
    });
  }

  onMessageReceived(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Event==${event.data}");
      redirection(context, json.decode(event.data['content']));
    });
  }

  redirection(BuildContext context, Map<String, dynamic> mapData) async {
    print("Event==$mapData");

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationView(data: mapData)));
  }
}
