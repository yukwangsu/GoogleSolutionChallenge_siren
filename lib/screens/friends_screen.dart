import 'package:flutter/material.dart';
import 'package:flutter_siren/models/friend_model.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:flutter_siren/widgets/friends/add_friend_dialog.dart';
import 'package:flutter_siren/widgets/friends/friend.dart';
import 'package:flutter_siren/widgets/widget_title.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  // todo: get friends
  // late Future<List<FriendModel>> friends;
  List<FriendModel> friends = [];

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

            // record
            Container(
              width: double.infinity,
              height: 57.0,
              decoration: BoxDecoration(
                color: const Color(grey),
                border: Border.all(
                  color: const Color(green),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Image.asset('assets/images/record_img.png'),
                  ),
                  const SizedBox(width: 15.0),
                  const Text(
                    'Say',
                    style: TextStyle(fontSize: 16),
                  ),
                  const Text(
                    ' signal ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(green),
                    ),
                  ),
                  const Text(
                    'to record...',
                    style: TextStyle(fontSize: 16),
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
                        child: const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.person_add_alt),
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
