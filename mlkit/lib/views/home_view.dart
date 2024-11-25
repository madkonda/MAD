
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'components/camera_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(title: Text('Image Labeler')),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return CameraView(
            title: 'Image Labeling',
            customPaint: controller.getCustomPaint,
            text: controller.getText,
            onImage: controller.processImage,
          );
        },
      ),
    );
  }
}
