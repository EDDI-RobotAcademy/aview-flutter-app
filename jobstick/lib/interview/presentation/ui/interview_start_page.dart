import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class InterviewStartPage extends StatefulWidget {
  @override
  _InterviewStartPageState createState() => _InterviewStartPageState();
}

class _InterviewStartPageState extends State<InterviewStartPage> {
  late CameraController _cameraController;
  late List<CameraDescription> cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.medium);
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
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
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: CameraPreview(_cameraController),
            ),
            ElevatedButton(
              onPressed: () {
                // 면접 시작 로직
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('면접이 시작되었습니다!')),
                );
              },
              child: Text('면접 시작', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
