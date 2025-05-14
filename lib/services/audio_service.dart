import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_siren/secrets/secrets.dart';
import 'package:flutter_siren/services/user_service.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AudioService {
  static Future<void> uploadAacFile(String filePath) async {
    final uri = Uri.parse(firebaseFunctionUri);
    final request = http.MultipartRequest('POST', uri);

    File audioFile = File(filePath);
    if (!await audioFile.exists()) {
      print("파일이 존재하지 않습니다.");
      return;
    }

    // userId
    request.fields['userId'] = await UserService.getUsercode();

    // aac audio file
    request.files.add(
      await http.MultipartFile.fromPath(
        'audio_file', // field name
        audioFile.path,
        // contentType: MediaType('audio', 'aac'), // ← AAC 설정
      ),
    );

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print('업로드 성공: $responseBody');
      } else {
        print('업로드 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('에러 발생: $e');
    }
  }

  static Future<void> testGet() async {
    final url = Uri.parse(firebaseFunctionUri);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('get 성공');
      } else {
        print('get 오류 발생: ${response.statusCode}');
      }
    } catch (e) {
      print('get 예외 발생: $e');
    }
  }

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

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': await UserService.getUsercode(),
          'storageUrl': storageUrl,
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
