import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_siren/services/audio_service.dart';
import 'package:flutter_siren/services/location_service.dart';
import 'package:flutter_siren/services/message_service.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_siren/services/signal_service.dart';
import 'package:flutter_siren/variables/variables.dart';
import 'package:flutter_siren/widgets/home/edit_signal_dialog.dart';
import 'package:flutter_siren/widgets/home/signal.dart';
import 'package:flutter_siren/widgets/widget_title.dart';
// import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_sound/flutter_sound.dart' as sound;
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // test variables
  int temp = 1;

  // detect variables
  late stt.SpeechToText _speech;
  bool _speechEnabled = false;
  bool _isListening = false;
  bool _isActivated = false;
  String _recognizedText = '';

  // signal variables
  late Future<List<String>> signalsFuture;
  List<String> signalList = [];

  // record, player variables
  Duration duration = Duration.zero; //총 시간
  Duration position = Duration.zero; //진행중인 시간
  final recorder = sound.FlutterSoundRecorder();
  bool isRecording = false; //녹음 상태
  String audioPath = ''; //녹음중단 시 경로 받아올 변수
  String playAudioPath = ''; //저장할때 받아올 변수 , 재생 시 필요

  //재생에 필요한 것들
  final AudioPlayer audioPlayer = AudioPlayer(); //오디오 파일을 재생하는 기능 제공
  bool isPlaying = false; //현재 재생중인지
  bool isPaused = false; //현재 일지 정지중인지
  List<FileSystemEntity> _audioFiles = [];

  @override
  void initState() {
    super.initState();
    // check fcm token
    checkFcmToken();

    // check location perm
    // LocationService.checkLocationPerm();
    checkLocationPerm();

    _speech = stt.SpeechToText();
    _initSpeech();

    // get signals
    getSignals();

    // get audio file
    _loadAudioFiles();

    //마이크 권한 요청, 녹음 초기화
    initRecorder();
    print("datetime now: ${DateTime.now()}");

    //재생 상태가 변경될 때마다 상태를 감지하는 이벤트 핸들러
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
        isPaused = state == PlayerState.paused;
      });
      print("헨들러 isplaying : $isPlaying");
    });

    //재생 파일의 전체 길이를 감지하는 이벤트 핸들러
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    //재생 중인 파일의 현재 위치를 감지하는 이벤트 핸들러
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
      print('Current position: $position');
    });
  }

  // check fcm token func
  void checkFcmToken() {
    if (!hasFcmToken) {
      hasFcmToken = true;
      MessageService.updateFcmToken();
    }
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

  Future<void> _loadAudioFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'recordings'); // recordings 디렉터리
    final dir = Directory(path);
    final files = dir
        .listSync()
        .where((f) =>
            f.path.endsWith('.aac') && FileSystemEntity.isFileSync(f.path))
        .toList();

    files.sort((a, b) =>
        b.statSync().modified.compareTo(a.statSync().modified)); // 최신순 정렬

    setState(() {
      _audioFiles = files;
    });
  }

  Future<void> playAudio(String audioPath) async {
    try {
      // if (!isPlaying) {
      //   await audioPlayer.stop(); // 이미 재생 중인 경우 정지시킵니다.
      // }

      await audioPlayer.setSourceDeviceFile(audioPath);
      print("duration: $duration");
      await Future.delayed(const Duration(seconds: 1));
      print("after wait duration: $duration");

      setState(() {
        duration = duration;
        isPlaying = true;
      });

      // audioPlayer.play;
      await audioPlayer.resume();

      print('오디오 재생 시작: $audioPath');
      print("duration: $duration");
    } catch (e) {
      print("audioPath : $audioPath");
      print("오디오 재생 중 오류 발생 : $e");
    }
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();

    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  //녹음 시작
  Future<void> record() async {
    await recorder.openRecorder();
    await recorder.startRecorder(
      toFile: 'audio',
      // important
      // codec: sound.Codec.pcm16WAV, // WAV 형식으로 저장
      // codec: sound.Codec.aacADTS,
    );
    setState(() {
      isRecording = true;
    });

    Future.delayed(const Duration(milliseconds: 10600), () async {
      if (recorder.isRecording) {
        await _stopRecording();
      }
    });
  }

  //저장함수
  Future<String> saveRecordingLocally() async {
    if (audioPath.isEmpty) return ''; // 녹음된 오디오 경로가 비어있으면 빈 문자열 반환

    final audioFile = File(audioPath);
    if (!audioFile.existsSync()) return ''; // 파일이 존재하지 않으면 빈 문자열 반환
    try {
      final directory = await getApplicationDocumentsDirectory();
      final newPath =
          p.join(directory.path, 'recordings'); // recordings 디렉터리 생성

      final now = DateTime.now();
      final formatter = DateFormat('MMMdd_HHmmss');
      final newFile = File(p.join(newPath, '${formatter.format(now)}.aac'));
      if (!(await newFile.parent.exists())) {
        await newFile.parent.create(recursive: true); // recordings 디렉터리가 없으면 생성
      }

      await audioFile.copy(newFile.path); // 기존 파일을 새로운 위치로 복사

      print('Complete Saving recording: ${newFile.path}');
      // playAudioPath = newFile.path;

      return newFile.path; // 새로운 파일의 경로 반환
    } catch (e) {
      print('Error saving recording: $e');
      return ''; // 오류 발생 시 빈 문자열 반환
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _isActivated = true;
      _recognizedText = '';
    });
    // start recording
    await record();
  }

  Future<void> _stopRecording() async {
    print('*** recording stop ***');
    _speech.stop(); // 음성 인식 중지

    if (recorder.isRecording) {
      try {
        final path = await recorder.stopRecorder();
        if (path == null) {
          print('녹음 중단 실패: 경로가 null입니다.');
          return;
        }

        audioPath = path;
        setState(() {
          isRecording = false;
          _isActivated = false;
        });

        final savedFilePath = await saveRecordingLocally(); // 파일 저장
        print("savedFilePath: $savedFilePath");

        await _loadAudioFiles();

        // upload aac audio file to firebase storage
        await AudioService.uploadAacFileToFirebase(savedFilePath);
      } catch (e) {
        print('녹음 중단 중 오류 발생: $e');
      }
    } else {
      print('녹음 중이 아님');
    }
  }

  String formatTime(Duration duration) {
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String result = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return result;
  }

  void _restartListening() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_isListening) {
        _startListening();
      }
    });
  }

  void _startListening() {
    if (_speech.isListening || _isListening) return;
    print('_startListening triggered $temp');
    temp++;
    _speech.listen(
      onResult: (result) {
        print('##speech.listen triggered $temp');

        final words = result.recognizedWords.toLowerCase();
        print('Heard: $words');

        if (!_isActivated) {
          if (signalList.any((signal) => words.contains(signal))) {
            _startRecording();
          }
        } else {
          // update speech to text
          if (result.finalResult) {
            setState(() {
              _recognizedText += '${result.recognizedWords}.\n';
            });
          }
        }
      },
      // localeId: 'ko_KR', // 한국어 설정
      localeId: 'en_US', // 영어 설정
      listenMode: stt.ListenMode.dictation,
      partialResults: false,
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

  Future<void> _deleteFile(String filePath) async {
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
      print('파일 삭제 완료: $filePath');
      await _loadAudioFiles();
    } else {
      print('파일이 존재하지 않습니다: $filePath');
    }
  }

  @override
  void dispose() {
    // _speech.stop();
    // recorder.closeRecorder();
    // audioPlayer.dispose();
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
              height: 20.0,
            ),

            // Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              // todo: logo svg
              child: Image.asset(
                'assets/images/small_logo.png',
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 22,
                    ),
                    // record widget
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 7.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Image.asset(
                                      'assets/images/record_img.png'),
                                ),
                                const SizedBox(width: 15.0),
                                _isActivated
                                    ? activatedText()
                                    : unActivatedText(),
                              ],
                            ),
                          ),
                          // if (_isActivated)
                          //   Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(vertical: 10.0),
                          //     child: Text(
                          //       _recognizedText,
                          //       style: const TextStyle(fontSize: 15),
                          //     ),
                          //   ),
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
                            children: _audioFiles
                                .map((file) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15.0),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 7, 20, 3),
                                        decoration: BoxDecoration(
                                          color: const Color(grey),
                                          border: Border.all(
                                            color: const Color(green),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(file.path
                                                      .split('/')
                                                      .last),
                                                  GestureDetector(
                                                    onTap: () async =>
                                                        await _deleteFile(
                                                            file.path),
                                                    child: const Icon(
                                                      Icons
                                                          .delete_forever_outlined,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SliderTheme(
                                              data: const SliderThemeData(
                                                inactiveTrackColor: Colors.grey,
                                              ),
                                              child: Slider(
                                                min: 0,
                                                max: playAudioPath == file.path
                                                    ? duration.inSeconds
                                                        .toDouble()
                                                    : Duration.zero.inSeconds
                                                        .toDouble(),
                                                value: playAudioPath ==
                                                        file.path
                                                    ? position.inSeconds
                                                        .toDouble()
                                                    : Duration.zero.inSeconds
                                                        .toDouble(),
                                                onChanged: (value) async {
                                                  setState(() {
                                                    position = Duration(
                                                        seconds: value.toInt());
                                                  });
                                                  await audioPlayer
                                                      .seek(position);
                                                },
                                                activeColor: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    playAudioPath == file.path
                                                        ? formatTime(position)
                                                        : formatTime(
                                                            Duration.zero),
                                                    style: const TextStyle(
                                                        color: Colors.brown),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  CircleAvatar(
                                                    radius: 15,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: IconButton(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 50),
                                                      icon: Icon(
                                                        isPlaying &&
                                                                playAudioPath ==
                                                                    file.path
                                                            ? Icons.pause
                                                            : Icons.play_arrow,
                                                        color: Colors.brown,
                                                      ),
                                                      iconSize: 25,
                                                      onPressed: () async {
                                                        print(
                                                            "isplaying 전 : $isPlaying");

                                                        if (isPlaying) {
                                                          print('오디오 pause');
                                                          await audioPlayer
                                                              .pause();
                                                        } else {
                                                          // resume
                                                          if (playAudioPath ==
                                                                  file.path &&
                                                              isPaused) {
                                                            print('오디오 resume');
                                                            await audioPlayer
                                                                .resume();
                                                          } else {
                                                            // play new audio
                                                            print(
                                                                '오디오 play new audio');
                                                            playAudioPath =
                                                                file.path;
                                                            position =
                                                                Duration.zero;
                                                            await playAudio(
                                                                playAudioPath);
                                                          }
                                                        }
                                                        print(
                                                            "isplaying 후 : $isPlaying");
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Text(
                                                    playAudioPath == file.path
                                                        ? formatTime(duration)
                                                        : formatTime(
                                                            Duration.zero),
                                                    style: const TextStyle(
                                                        color: Colors.brown),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget unActivatedText() {
    return GestureDetector(
      onTap: _startRecording,
      child: const Row(
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
      ),
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
