import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_siren/models/friend_model.dart';

class UserService {
  static Future<String> getUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '[username error]';

    final ref = FirebaseDatabase.instance.ref('username/${user.uid}');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      return snapshot.value as String;
    } else {
      await ref.set('default-name');
      return 'default-name';
    }
  }

  static Future<void> editUsername(String newUsername) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseDatabase.instance.ref('username/${user.uid}');
    await ref.set(newUsername);
  }

  static Future<String> getUsercode() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '[usercode error]';

    return user.uid;
  }

  static Future<List<FriendModel>> getFriendList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final ref = FirebaseDatabase.instance.ref('friends/${user.uid}');
    final snapshot = await ref.get();
    List<FriendModel> result = [];

    if (snapshot.exists) {
      List<String> uidList = List<String>.from(snapshot.value as List);
      for (int i = 0; i < uidList.length; i++) {
        final friendRef =
            FirebaseDatabase.instance.ref('username/${uidList[i]}');
        final friendSnapshot = await friendRef.get();

        if (friendSnapshot.exists) {
          result.add(FriendModel.fromJson(
              {'uid': uidList[i], 'username': friendSnapshot.value as String}));
        } else {
          result.add(FriendModel.fromJson(
              {'uid': uidList[i], 'username': 'no-username'}));
        }
      }
      return result;
    } else {
      return result;
    }
  }

  static Future<void> addFriendToList(String uid) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // check new Uid
    final checkRef = FirebaseDatabase.instance.ref('username/$uid');
    final checkSnapshot = await checkRef.get();
    if (!checkSnapshot.exists || uid == user.uid) {
      // not exist uid or my uid
      return;
    }

    // my friend list
    final myRef = FirebaseDatabase.instance.ref('friends/${user.uid}');
    final mySnapshot = await myRef.get();
    List<String> myList = [];
    if (mySnapshot.exists) {
      myList = List<String>.from(mySnapshot.value as List);
    }
    if (!myList.contains(uid)) {
      myList.add(uid);
      await myRef.set(myList);
    }

    // friend`s friend list
    final friendRef = FirebaseDatabase.instance.ref('friends/$uid');
    final friendSnapshot = await friendRef.get();
    List<String> friendList = [];

    if (friendSnapshot.exists) {
      friendList = List<String>.from(friendSnapshot.value as List);
    }
    if (!friendList.contains(user.uid)) {
      friendList.add(user.uid);
      await friendRef.set(friendList);
    }
  }
}
