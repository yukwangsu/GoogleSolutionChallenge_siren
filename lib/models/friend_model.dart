class FriendModel {
  final String uid, username;

  FriendModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        username = json['username'];
}
