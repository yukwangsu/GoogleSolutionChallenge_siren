class FriendModel {
  final String id, name;

  FriendModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
