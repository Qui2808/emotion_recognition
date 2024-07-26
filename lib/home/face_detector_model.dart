import 'package:camera/camera.dart';
import 'package:facial_emotions/home/emotion_detection.dart';
import 'package:facial_emotions/home/face_detector_painter.dart';
import 'package:facial_emotions/home/face_recognition/ml_service.dart';
import 'package:facial_emotions/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../utils/object_box_manager.dart';
import '../objectbox.g.dart';


class FaceDetectorViewModel with ChangeNotifier {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableContours: true,
      enableTracking: true,
      // enableLandmarks: true,
    ),
  );

  final ObjectBoxManager objectBoxManager;  // Thêm ObjectBoxManager
  FaceDetectorViewModel({required this.objectBoxManager});

  bool _canProcess = true;
  bool _isBusy = false;
  double _smilingProbability = 0;
  double _rightEyeOpenProbability = 0;
  double _leftEyeOpenProbability = 0;
  CustomPaint? _customPaint;
  String? _text;
  String? _imgSmile;
  CameraLensDirection _cameraLensDirection = CameraLensDirection.front;
  List<double>? emo;
  EmotionDetection emotionDetection = EmotionDetection();
  List<List<double>?> arrEmo = [];

  CustomPaint? get customPaint => _customPaint;
  String? get text => _text;
  String? get imgSmile => _imgSmile;
  double get smile => _smilingProbability;
  double get rightEyeOpen => _rightEyeOpenProbability;
  double get leftEyeOpen => _leftEyeOpenProbability;
  List<double>? get lstEmotion => emo;
  CameraLensDirection get cameraLensDirection => _cameraLensDirection;

  void setCameraLensDirection(CameraLensDirection direction) {
    _cameraLensDirection = direction;
    notifyListeners();
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
    _isBusy = true;
    // _text = null;
    notifyListeners();

    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
      if(faces.isNotEmpty){
        // print('####### smile: ${faces.first.smilingProbability} ########');
        // print('####### rightEye: ${faces.first.rightEyeOpenProbability} ########');
        // print('####### leftEye: ${faces.first.leftEyeOpenProbability} ########');
        print('####### id: ${faces.first.trackingId} ########');
        //detectSmile(faces.first.smilingProbability);
        if(faces.first.smilingProbability != null) {
          _smilingProbability = faces.first.smilingProbability!;
        }
        if(faces.first.leftEyeOpenProbability != null) {
          _rightEyeOpenProbability = faces.first.leftEyeOpenProbability!;
        }
        if(faces.first.rightEyeOpenProbability != null) {
          _leftEyeOpenProbability = faces.first.rightEyeOpenProbability!;
        }
        // MLService _mlService = new MLService();
        // User? user = await _mlService.predict(
        //     inputImage,
        //     faces.first,
        //     false,
        //     "Qui");

        emo = await emotionDetection.predict(inputImage, faces.first);
        List<double>? combinedArray;
        if (faces.first.trackingId != null) {
          combinedArray = [faces.first.trackingId!.toDouble()];
          combinedArray.addAll(emo!);
        }
        saveList(combinedArray);
        print('####### count: ${arrEmo.length} ########');

        notifyListeners();
      }
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      emo = null;
      print('@@@@@@@@@@@@@@@ emotion Null: ${emo} @@@@@@@@@@@@@@@@');
      _customPaint = null;
    }
    _isBusy = false;
    notifyListeners();
  }



  Future<void> saveList(List<double>? arr) async {
    List<double>? formattedList;
    if(arr != null){
      formattedList = arr.map((double number) {
        // Chuyển đổi số thành chuỗi có 3 chữ số thập phân
        String formattedNumber = number.toStringAsFixed(3);

        // Chuyển lại từ chuỗi thành số double
        return double.parse(formattedNumber);
      }).toList();
    }
    print('####### emotion: ${formattedList} ########');
    arrEmo.add(formattedList);
    print('####### emotion222222: ${arrEmo} ########');
  }


  Future<void> saveEmotionData(String videoName, String datetime, List<List<double>?> emotionArray) async {
    var object = await objectBoxManager.createMyObject(videoName, datetime, emotionArray);
    await objectBoxManager.saveMyObjectData(object);
    print("????????????????? Đã lưu  ?????????????");
    print(arrEmo);
  }



  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }
}
