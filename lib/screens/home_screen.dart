import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isActivated = false; // "시작" 감지 여부
  String _recognizedText = 'Say "시작" to begin...'; // 초기 메시지

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (status) {
        print('Status: $status');
        if (status == 'notListening') {
          _isListening = false;
          _restartListening();
        }
      },
      onError: (error) {
        print('Error: $error');
        _isListening = false;
      },
    );

    if (_speechEnabled) {
      _startListening();
    }
  }

  void _restartListening() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!_isListening) {
        _startListening();
      }
    });
  }

  void _startListening() {
    if (_speech.isListening || _isListening) return;

    _speech.listen(
      onResult: (result) {
        final words = result.recognizedWords.toLowerCase();
        print('Heard: $words');

        if (!_isActivated) {
          if (words.contains('시작')) {
            setState(() {
              // todo: 녹음 시작 기능 추가
              //
              _isActivated = true;
              _recognizedText = ''; // 시작 시 초기화
            });
          }
        } else {
          if (words.contains('그만')) {
            setState(() {
              // todo: 녹음 중단 기능 추가
              //
              _isActivated = false; // "그만"이 들리면 멈춤
              _speech.stop(); // 녹음 중지
            });
          } else if (result.finalResult) {
            setState(() {
              _recognizedText += ' ${result.recognizedWords}'; // 누적 텍스트
            });
          }
        }
      },
      localeId: 'ko_KR', // 한국어 설정
      listenMode: stt.ListenMode.dictation,
      partialResults: false, // 부분 결과를 받지 않음
      cancelOnError: false,
      pauseFor: const Duration(hours: 1),
      listenFor: const Duration(hours: 1),
    );

    _isListening = true;
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech Triggered by "시작"')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          _recognizedText,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
