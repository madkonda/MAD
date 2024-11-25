import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import '../../main.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.title,
    required this.customPaint,
    this.text,
    required this.onImage,
    this.onScreenModeChanged,
    this.initialDirection = CameraLensDirection.back,
  }) : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function(ScreenMode mode)? onScreenModeChanged;
  final CameraLensDirection initialDirection;

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  ScreenMode _mode = ScreenMode.liveFeed;
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _startLiveFeed();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _mode == ScreenMode.liveFeed ? _liveFeedBody() : _galleryBody(),
      floatingActionButton: _mode == ScreenMode.liveFeed
          ? FloatingActionButton(
              onPressed: _switchLiveCamera,
              child: Icon(Icons.flip_camera_android_outlined),
            )
          : null,
    );
  }

  Widget _liveFeedBody() {
    if (_controller?.value.isInitialized == false) return Container();
    return CameraPreview(_controller!);
  }

  Widget _galleryBody() {
    // Placeholder for gallery
    return Center(child: Text("Gallery Mode"));
  }

  Future _startLiveFeed() async {
    var cameras = await availableCameras();
    final camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.medium);
    await _controller?.initialize();
    setState(() {});
  }

  Future _stopLiveFeed() async {
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    await _stopLiveFeed();
    await _startLiveFeed();
  }
}
