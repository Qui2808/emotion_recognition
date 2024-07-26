import 'package:facial_emotions/home/view/detector_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../face_detector_model.dart';

class FaceDetectorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FaceDetectorViewModel>(
        builder: (context, model, child) {
          return DetectorView(
            title: 'Face Detector',
            customPaint: model.customPaint,
            text: model.text,
            onImage: model.processImage,
            initialCameraLensDirection: model.cameraLensDirection,
            onCameraLensDirectionChanged: (value) => model.setCameraLensDirection(value),
          );
        },
      ),
    );
  }
}
