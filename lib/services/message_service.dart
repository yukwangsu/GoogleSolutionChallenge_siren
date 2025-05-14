import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessageService {
  static Future<void> updateFcmToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    String? token = await messaging.getToken();

    if (token != null) {
      print("*** FCM token: $token");

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      // update email realtime database(uid: user email)
      final emailRef = FirebaseDatabase.instance.ref('userEmail/${user.uid}');
      await emailRef.set(user.email);

      // update fcm token on realtime database(uid: fcmtoken)
      final tokenRef = FirebaseDatabase.instance.ref('fcmToken/${user.uid}');
      await tokenRef.set(token);
    } else {
      print("*** get FCM error");
    }
  }
}
