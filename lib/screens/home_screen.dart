import 'package:flutter/material.dart';
import 'package:flutter_siren/services/signal_service.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:flutter_siren/widgets/home/edit_signal_dialog.dart';
import 'package:flutter_siren/widgets/home/signal.dart';
import 'package:flutter_siren/widgets/widget_title.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isActivated = false; // "시작" 감지 여부
  String _recognizedText = 'Say "시작" to begin...'; // 초기 메시지
  late Future<List<String>> signalsFuture;
  List<String> signalList = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();

    // get signals
    getSignals();
  }

  // get signals func
  void getSignals() {
    if (cachedSignalList != null) {
      setState(() {
        signalList = cachedSignalList!;
        signalsFuture = Future.value(signalList);
      });
      return;
    }

    signalsFuture = SignalService.getSignalWordList().then((list) {
      setState(() {
        signalList = list;
        cachedSignalList = list; // cache
      });
      return list;
    });
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
          if (signalList.any((signal) => words.contains(signal))) {
            setState(() {
              // todo: 녹음 시작 기능 추가
              //
              _isActivated = true;
              _recognizedText = ''; // 시작 시 초기화
            });
          }
        } else {
          // todo: 녹음 종료하는 로직 추가 필요
          if (words.contains('녹음 종료')) {
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
      // localeId: 'ko_KR', // 한국어 설정
      localeId: 'en_US', // 영어 설정
      listenMode: stt.ListenMode.dictation,
      partialResults: false, // 부분 결과를 받지 않음
      cancelOnError: false,
      pauseFor: const Duration(hours: 1),
      listenFor: const Duration(hours: 1),
    );

    _isListening = true;
  }

  void onClickEditSignalHandler() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditSignalDialog(
          signals: List<String>.from(signalList),
        );
      },
    ).then((_) {
      // update signals
      getSignals();
    });
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
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

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 22,
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
                          _isActivated ? activatedText() : unActivatedText(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),

                    // signals
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const WidgetTitle(title: 'Signals'),
                            GestureDetector(
                              onTap: onClickEditSignalHandler,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Wrap(
                            spacing: 9.0,
                            runSpacing: 9.0,
                            children: signalList
                                .map((word) => Signal(word: '# $word'))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),

                    // todo: Record Notes
                    // Notes
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WidgetTitle(title: 'Notes'),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: signalList
                                .map((word) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 9.0),
                                      child: Signal(word: '# $word'),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )

                    // Text(
                    //   _recognizedText,
                    //   style: const TextStyle(fontSize: 20),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row unActivatedText() {
    return const Row(
      children: [
        Text(
          'Say',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          ' signal ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(green),
          ),
        ),
        Text(
          'to record...',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Row activatedText() {
    return const Row(
      children: [
        Text(
          'Recording ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(green),
          ),
        ),
        Text(
          'your situation...',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
