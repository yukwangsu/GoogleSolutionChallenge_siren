import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_siren/models/friend_model.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:flutter_siren/widgets/friends/add_friend_dialog.dart';
import 'package:flutter_siren/widgets/friends/friend.dart';
import 'package:flutter_siren/widgets/widget_title.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({
    super.key,
  });

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  // todo: get friends
  // late Future<List<FriendModel>> friends;
  List<FriendModel> friends = [];

  // todo: get username
  String username = 'username';

  // todo: get usercode
  String usercode = 'asdfds233adas';

  @override
  void initState() {
    super.initState();

    // todo: get friends
    // ex) friends = ApiService.getToonById(widget.id);
    friends = [
      FriendModel.fromJson({'id': '1', 'name': 'Alice'}),
      FriendModel.fromJson({'id': '2', 'name': 'Bob'}),
      FriendModel.fromJson({'id': '3', 'name': 'Charlie'}),
      FriendModel.fromJson({'id': '4', 'name': 'David'}),
      FriendModel.fromJson({'id': '5', 'name': 'Eve'}),
      FriendModel.fromJson({'id': '6', 'name': 'Faythe'}),
      FriendModel.fromJson({'id': '7', 'name': 'Grace'}),
      FriendModel.fromJson({'id': '8', 'name': 'Heidi'}),
      FriendModel.fromJson({'id': '9', 'name': 'Ivan'}),
      FriendModel.fromJson({'id': '10', 'name': 'Judy'}),
    ];
  }

  Future<void> _signOut(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  void onClickCodeHandler(String copy) {
    Clipboard.setData(ClipboardData(text: copy));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Your code has been copied: $copy')),
    );
  }

  void onClickAddFriendHandler() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddFriendDialog();
      },
    ).then((_) {
      setState(() {
        // todo: update friends
        //
        // friends = updatedFriends;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 55.0,
            ),

            // Logo
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              // todo: logo svg
              child: Text('Logo'),
            ),
            const SizedBox(
              height: 44.0,
            ),

            // user
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(grey),
                border: Border.all(
                  color: const Color(green),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // todo: get user name
                        username,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(green),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _signOut(context),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 9.0),
                          child: Row(
                            children: [
                              Text(
                                'Sign out',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF565555),
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Icon(
                                Icons.logout,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person_outline_outlined,
                          size: 45,
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        const Text(
                          'Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF565555),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => onClickCodeHandler(usercode),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    // todo: get usercode
                                    usercode,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF565555),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Icon(
                                  Icons.copy,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 22.0,
            ),

            // your friends
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const WidgetTitle(title: 'Your Friends'),
                      GestureDetector(
                        onTap: onClickAddFriendHandler,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            Icons.person_add_alt,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3.0),
                  // FutureBuilder(
                  //   future: friends,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       return Expanded(
                  //         child: makeFriendList(snapshot),
                  //       );
                  //     }
                  //     return const Center(
                  //       child: CircularProgressIndicator(),
                  //     );
                  //   },
                  // ),
                  Expanded(
                    child: makeFriendList(friends),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ListView makeFriendList(AsyncSnapshot<List<FriendModel>> snapshot) {
  //   return ListView.separated(
  //     scrollDirection: Axis.vertical,
  //     itemCount: snapshot.data!.length,
  //     padding: const EdgeInsets.only(top: 5, bottom: 30),
  //     itemBuilder: (context, index) {
  //       var friend = snapshot.data![index];
  //       return Friend(
  //         id: friend.id,
  //         name: friend.name,
  //       );
  //     },
  //     separatorBuilder: (context, index) => const SizedBox(height: 12),
  //   );
  // }
  ListView makeFriendList(List<FriendModel> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: snapshot.length,
      padding: const EdgeInsets.only(top: 5, bottom: 30),
      itemBuilder: (context, index) {
        var friend = snapshot[index];
        return Friend(
          id: friend.id,
          name: friend.name,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
