import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_siren/models/friend_model.dart';
import 'package:flutter_siren/services/user_service.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:flutter_siren/widgets/friends/add_friend_dialog.dart';
import 'package:flutter_siren/widgets/friends/edit_name_dialog.dart';
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
  String username = '';
  String usercode = '';
  List<FriendModel> friendList = [];

  @override
  void initState() {
    super.initState();

    getUsername();
    getUsercode();
    getFrieds();
  }

  Future<void> _signOut(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  void getUsername() {
    if (cachedUsername != null) {
      setState(() {
        username = cachedUsername!;
      });
      return;
    } else {
      UserService.getUsername().then((name) {
        setState(() {
          username = name;
          cachedUsername = name; // cache
        });
      });
    }
  }

  void getUsercode() {
    if (cachedUsercode != null) {
      setState(() {
        usercode = cachedUsercode!;
      });
      return;
    } else {
      UserService.getUsercode().then((code) {
        setState(() {
          usercode = code;
          cachedUsercode = code; // cache
        });
      });
    }
  }

  void getFrieds() {
    if (cachedFriendList != null) {
      setState(() {
        friendList = cachedFriendList!;
      });
      return;
    }

    UserService.getFriendList().then((list) {
      setState(() {
        friendList = list;
        cachedFriendList = list; // cache
      });
    });
  }

  void onClickEditNameHandler() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const EditNameDialog();
      },
    ).then((_) {
      getUsername();
    });
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
        getFrieds();
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
              height: 22.0,
            ),

            // scroll
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 22.0,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // username
                              GestureDetector(
                                onTap: () => onClickEditNameHandler(),
                                child: Row(
                                  children: [
                                    Text(
                                      username,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(green),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Icon(
                                      Icons.edit_outlined,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),

                              // sign out
                              GestureDetector(
                                onTap: () => _signOut(context),
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 9.0),
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
                                        width: 3,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 9.0),
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
                                            usercode,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
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
                    Column(
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
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                          child: Column(
                            children: friendList
                                .map((friend) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Friend(
                                          id: friend.uid,
                                          name: friend.username),
                                    ))
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
