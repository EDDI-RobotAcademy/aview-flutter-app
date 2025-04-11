import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // 음성 인식 라이브러리 추가
import 'package:permission_handler/permission_handler.dart'; // 권한 요청 패키지

class InterviewStartPage extends StatefulWidget {
  @override
  _InterviewStartPageState createState() => _InterviewStartPageState();
}

class _InterviewStartPageState extends State<InterviewStartPage> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;
  final FlutterTts _flutterTts = FlutterTts();
  stt.SpeechToText _speechToText = stt.SpeechToText(); // 음성 인식 객체
  bool _isListening = false; // 음성 인식 상태
  String _recognizedText = ''; // 변환된 텍스트 저장

  @override
  void initState() {
    super.initState();
    _requestPermissions();  // 권한 요청
    _initializeCamera();
    _initializeTTS();
    _initializeSpeechToText(); // 음성 인식 초기화
  }

  // 권한 요청 함수
  Future<void> _requestPermissions() async {
    // 마이크 권한 요청
    PermissionStatus microphonePermission = await Permission.microphone.request();
    if (!microphonePermission.isGranted) {
      print("마이크 권한이 필요합니다.");
      return;
    }

    // 카메라 권한 요청
    PermissionStatus cameraPermission = await Permission.camera.request();
    if (!cameraPermission.isGranted) {
      print("카메라 권한이 필요합니다.");
      return;
    }

    // 권한이 모두 승인되었을 때 처리
    print("모든 권한이 승인되었습니다.");
  }

  // 카메라 초기화
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras[0], // 혹시 front 카메라가 없으면 기본값
    );

    _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
    await _cameraController.initialize();

    setState(() {
      _isCameraInitialized = true;
    });
  }

  // TTS 초기화
  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("ko-KR");
    await _flutterTts.setSpeechRate(0.5);
  }

  // 음성 인식 초기화
  Future<void> _initializeSpeechToText() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = false;
      });
    }
  }

  // 면접 시작 TTS 음성 출력
  Future<void> _speakInterviewStart() async {
    await _flutterTts.speak("면접이 시작되었습니다! 지금부터 질문을 시작하겠습니다!");
  }

  // 음성 인식 시작
  void _startListening() {
    _speechToText.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
        });
        print("인식된 텍스트: $_recognizedText");
      },
      partialResults: true,
      localeId: "ko_KR",
      onSoundLevelChange: (level) {
        print("음성 레벨: $level");
      },
      onDevice: true,
    );

    // 자동 종료됐는지 감지하고, 재시작 처리
    _speechToText.statusListener = (status) {
      print("음성 인식 상태: $status");

      if (status == 'done' && _isListening) {
        // 잠깐 쉬고 재시작
        Future.delayed(Duration(milliseconds: 500), () {
          if (_isListening) {
            _startListening(); // 계속 듣기
          }
        });
      }
    };

    setState(() {
      _isListening = true;
    });
  }

  // 음성 인식 종료
  void _stopListening() {
    _speechToText.stop();
    _speechToText.statusListener = null; // 리스너 제거
    setState(() {
      _isListening = false;
    });
    _sendRecognizedTextToServer();
  }

  // 음성 인식된 텍스트 서버로 전송
  Future<void> _sendRecognizedTextToServer() async {
    print("인식된 텍스트: $_recognizedText");
    // 여기에 변환된 텍스트를 서버로 전송하는 로직을 추가합니다.
    // 예: HTTP 요청으로 서버에 텍스트를 보내는 코드
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('면접 시작')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('면접 시작')),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_cameraController),
          ),
          SizedBox(height: 20),
          // 면접 시작 버튼
          ElevatedButton(
            onPressed: () async {
              await _speakInterviewStart();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('면접이 시작되었습니다! 지금부터 질문을 시작하겠습니다!')),
              );
              _startListening();
            },
            child: Text('면접 시작', style: TextStyle(fontSize: 18)),
          ),
          SizedBox(height: 10),

          // 답변 진행 버튼
          ElevatedButton(
            onPressed: !_isListening ? _startListening : null,
            child: Text('답변 진행'),
          ),
          SizedBox(height: 10),

          // 답변 완료 버튼
          ElevatedButton(
            onPressed: _isListening ? _stopListening : null,
            child: Text('답변 완료'),
          ),
          SizedBox(height: 10),

          // 음성 인식 상태 표시
          Text(
            _isListening ? '음성 인식 중...' : '음성 인식 종료',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '인식된 텍스트:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              _recognizedText.isNotEmpty ? _recognizedText : '(아직 인식된 텍스트가 없습니다)',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
