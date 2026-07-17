import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';

class ScanIdLayout extends StatelessWidget {
  final CameraController? controller;
  final bool isProcessing;
  final bool permissionDenied;
  final VoidCallback onBack;
  final VoidCallback onCapture;
  final VoidCallback onRequestPermission;

  const ScanIdLayout({
    super.key,
    required this.controller,
    required this.isProcessing,
    required this.permissionDenied,
    required this.onBack,
    required this.onCapture,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const AppText(text: 'Align your National ID within the frame', textSize: 15, textColor: Colors.white),

              const SizedBox(height: 40),

              AspectRatio(
                aspectRatio: 300 / 190,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildCameraArea(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              AppText(
                text: permissionDenied
                    ? 'Camera access is required to scan your ID.'
                    : 'Make sure all four corners are visible and the text is readable.',
                textSize: 13,
                textColor: Colors.white70,
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: permissionDenied
                    ? ElevatedButton(onPressed: onRequestPermission, child: const Text('Grant Camera Permission'))
                    : GestureDetector(
                        onTap: (isProcessing || !_isReady) ? null : onCapture,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isReady ? Colors.white : Colors.white24,
                            border: Border.all(color: Colors.white38, width: 4),
                          ),
                          child: isProcessing
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(strokeWidth: 3),
                                )
                              : null,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _isReady => controller != null && controller!.value.isInitialized;

  Widget _buildCameraArea() {
    if (permissionDenied) {
      return const Center(child: Icon(Icons.no_photography, color: Colors.white54, size: 48));
    }

    if (!_isReady) {
      return const Center(child: CircularProgressIndicator(color: Colors.white70));
    }

    return CameraPreview(controller!);
  }
}
