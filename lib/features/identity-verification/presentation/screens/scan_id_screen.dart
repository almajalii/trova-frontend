import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:trova/features/identity-verification/logic/id_ocr_parser.dart';
import 'package:trova/features/identity-verification/logic/identity_info.dart';
import 'package:trova/features/identity-verification/presentation/screens/scan_verified_screen.dart';
import 'package:trova/features/identity-verification/presentation/widget/scan_id_layout.dart';

class ScanIdScreen extends StatefulWidget {
  final ValueChanged<String>? onVerified;
  const ScanIdScreen({super.key, this.onVerified});

  @override
  State<ScanIdScreen> createState() => _ScanIdScreenState();
}

class _ScanIdScreenState extends State<ScanIdScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isProcessing = false;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  // Camera resources have to be managed manually on lifecycle changes as of
  // camera 0.5.0+ — see the "Handling Lifecycle states" section of the
  // camera package docs. Without this, backgrounding the app while this
  // screen is open can leave the camera in a bad state on resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    setState(() => _permissionDenied = false);

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _permissionDenied = true);
        return;
      }

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(backCamera, ResolutionPreset.high, enableAudio: false);

      await controller.initialize();
      if (!mounted) return;

      setState(() => _controller = controller);
    } on CameraException catch (e) {
      if (e.code == 'CameraAccessDenied' ||
          e.code == 'CameraAccessDeniedWithoutPrompt' ||
          e.code == 'CameraAccessRestricted') {
        if (mounted) setState(() => _permissionDenied = true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Camera error: ${e.description ?? e.code}')));
        }
      }
    }
  }

  Future<void> _handleCapture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() => _isProcessing = true);

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final photo = await controller.takePicture();
      final inputImage = InputImage.fromFilePath(photo.path);
      final recognizedText = await textRecognizer.processImage(inputImage);

      final lines = recognizedText.text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

      final guess = IdOcrParser.parse(lines);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScanVerifiedScreen(
            info: IdentityInfo(fullName: guess.fullName ?? '', nationalId: guess.nationalId ?? ''),
            onVerified: widget.onVerified,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not read the ID. Please try again. ($e)')));
      }
    } finally {
      await textRecognizer.close();
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScanIdLayout(
        controller: _controller,
        isProcessing: _isProcessing,
        permissionDenied: _permissionDenied,
        onBack: () => Navigator.pop(context),
        onCapture: _handleCapture,
        onRequestPermission: _initializeCamera,
      ),
    );
  }
}
