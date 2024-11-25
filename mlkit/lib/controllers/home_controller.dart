
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../views/components/labeling_painter.dart';

class HomeController extends GetxController {
  late ImageLabeler _imageLabeler;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  String? get getText => _text;
  CustomPaint? get getCustomPaint => _customPaint;

  @override
  void onInit() {
    super.onInit();
    _initializeLabeler();
  }

  void _initializeLabeler() {
    _imageLabeler = ImageLabeler(options: ImageLabelerOptions());
    _canProcess = true;
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
    _isBusy = true;

    final labels = await _imageLabeler.processImage(inputImage);
    _customPaint = CustomPaint(painter: LabelDetectorPainter(labels));
    _isBusy = false;
    update();
  }

  @override
  void onClose() {
    _imageLabeler.close();
    super.onClose();
  }
}
