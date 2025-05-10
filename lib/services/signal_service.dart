import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignalService {
  static Future<List<String>> getSignalWordList() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final ref = FirebaseDatabase.instance.ref('signals/${user.uid}');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      return List<String>.from(snapshot.value as List);
    } else {
      return [];
    }
  }

  static Future<void> addSignalWordToList(String word) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseDatabase.instance.ref('signals/${user.uid}');

    final snapshot = await ref.get();
    List<dynamic> currentList = [];

    if (snapshot.exists) {
      currentList = List.from(snapshot.value as List);
    }

    currentList.add(word);
    await ref.set(currentList);
  }

  static Future<void> deleteSignalWord(String wordToDelete) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = FirebaseDatabase.instance.ref('signals/${user.uid}');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      List<String> currentList = List<String>.from(snapshot.value as List);

      if (currentList.contains(wordToDelete)) {
        currentList.remove(wordToDelete);
        await ref.set(currentList);
      }
    }
  }
}
