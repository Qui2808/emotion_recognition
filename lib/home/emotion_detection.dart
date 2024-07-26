import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

class EmotionDetection {
  late Interpreter interpreter;

  EmotionDetection() {
    loadModel();
  }

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/final_model_face_emotion.tflite');
  }

  Future<List<double>> predict(InputImage inputImage, Face faceDetected) async {
    imglib.Image croppedImage = await _cropFace(inputImage, faceDetected);
    imglib.Image resizedImage = imglib.copyResize(croppedImage, width: 224, height: 224);

    var input = List.generate(1, (i) => List.generate(224, (j) => List.generate(224, (k) => List.generate(3, (l) => 0.0))));
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        var pixel = resizedImage.getPixel(x, y);
        input[0][y][x][0] = pixel.r / 255.0;
        input[0][y][x][1] = pixel.g / 255.0;
        input[0][y][x][2] = pixel.b / 255.0;
      }
    }

    var output = List.generate(1, (i) => List.generate(7, (j) => 0.0));

    interpreter.run(input, output);

    // var emotions = ['Angry', 'Disgust', 'Fear', 'Happy', 'Neutral', 'Sad', 'Surprise'];
    // int maxIndex = output[0].indexOf(output[0].reduce((curr, next) => curr > next ? curr : next));
    //
    // return emotions[maxIndex];
    return output[0];
  }

  Future<imglib.Image> _cropFace(InputImage inputImage, Face faceDetected) async {
    imglib.Image convertedImage = await decodeYUV420SP(inputImage);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(convertedImage, x: x.round(), y: y.round(), width: w.round(), height: h.round());
  }

  imglib.Image decodeYUV420SP(InputImage image) {
    final width = image.metadata!.size.width.toInt();
    final height = image.metadata!.size.height.toInt();

    Uint8List yuv420sp = image.bytes!;
    var rotationOfCamera = 0;
    if (image.metadata != null && image.metadata!.rotation.rawValue != 0) {
      rotationOfCamera = image.metadata!.rotation.rawValue;
    }
    return decodeYUV420SP_from_camera(width, height, yuv420sp, rotationOfCamera);
  }

  imglib.Image decodeYUV420SP_from_camera(int width, int height, Uint8List yuv420sp, int rotationOfCamera) {
    var outImg = imglib.Image(width: width, height: height);

    final int frameSize = width * height;

    for (int j = 0, yp = 0; j < height; j++) {
      int uvp = frameSize + (j >> 1) * width, u = 0, v = 0;
      for (int i = 0; i < width; i++, yp++) {
        int y = (0xff & yuv420sp[yp]) - 16;
        if (y < 0) y = 0;
        if ((i & 1) == 0) {
          v = (0xff & yuv420sp[uvp++]) - 128;
          u = (0xff & yuv420sp[uvp++]) - 128;
        }
        int y1192 = 1192 * y;
        int r = (y1192 + 1634 * v);
        int g = (y1192 - 833 * v - 400 * u);
        int b = (y1192 + 2066 * u);

        if (r < 0) {
          r = 0;
        } else if (r > 262143) {
          r = 262143;
        }
        if (g < 0) {
          g = 0;
        } else if (g > 262143) {
          g = 262143;
        }
        if (b < 0) {
          b = 0;
        } else if (b > 262143) {
          b = 262143;
        }
        outImg.setPixelRgb(i, j, ((r << 6) & 0xff0000) >> 16,
            ((g >> 2) & 0xff00) >> 8, (b >> 10) & 0xff);
      }
    }

    if (rotationOfCamera != 0) {
      outImg = imglib.copyRotate(outImg, angle: rotationOfCamera);
    }
    return outImg;
  }
}

