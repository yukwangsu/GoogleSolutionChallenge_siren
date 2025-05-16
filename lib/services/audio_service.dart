import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_siren/secrets/secrets.dart';
import 'package:flutter_siren/services/location_service.dart';
import 'package:flutter_siren/services/user_service.dart';
import 'package:flutter_siren/variables/variables.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:location/location.dart';

class AudioService {
  static Future<void> uploadAacFileToFirebase(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      print("파일이 존재하지 않습니다.");
      return;
    }

    try {
      final fileName = file.uri.pathSegments.last;
      final storageRef =
          FirebaseStorage.instance.ref().child('audio/$fileName');

      // 업로드 시작
      final uploadTask = storageRef.putFile(
        file,
        SettableMetadata(contentType: 'audio/aac'),
      );

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      final gsUrl = 'gs://${snapshot.ref.bucket}/${snapshot.ref.fullPath}';
      sendStorageUrlAndUserId(storageUrl: gsUrl);

      print('업로드 완료. 다운로드 URL: $downloadUrl');
      print('업로드 완료. gsUrl URL: $gsUrl');
    } catch (e) {
      print('업로드 실패: $e');
    }
  }

  static Future<void> sendStorageUrlAndUserId({
    required String storageUrl,
  }) async {
    final uri = Uri.parse(firebaseFunctionUri);

    late double latitude;
    late double longitude;
    LocationData? location = await getCurrentLocation();
    if (location == null) {
      latitude = defaultLatitude;
      longitude = defaultLongitude;
    } else {
      latitude = location.latitude!;
      longitude = location.longitude!;
    }
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': await UserService.getUsercode(),
          'storageUrl': storageUrl,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        print('전송 성공: ${response.body}');
      } else {
        print('전송 실패: ${response.statusCode}');
        print('응답: ${response.body}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }
}
