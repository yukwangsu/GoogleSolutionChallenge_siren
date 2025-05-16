import 'package:flutter_siren/models/friend_model.dart';

const int green = 0xFF7B9E89;
const int light_green = 0xFFA3C9A8;
const int grey = 0xFFF5F5F5;

int maxUsernameLength = 15;

List<String>? cachedSignalList;
String? cachedUsername;
String? cachedUsercode;
List<FriendModel>? cachedFriendList;
bool hasFcmToken = true;

double defaultLatitude = 37.5678;
double defaultLongitude = 126.9393;
