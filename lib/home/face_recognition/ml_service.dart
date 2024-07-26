import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import '../../../models/user.dart';

class MLService {
  late Interpreter interpreter;
  List? predictedArray;

  Future<User?> predict(InputImage inputImage, Face face, bool loginUser, String name) async {
    List input = await _preProcess(inputImage, face);
    input = input.reshape([1, 112, 112, 3]);

    List output = List.generate(1, (index) => List.filled(192, 0));

    await initializeInterpreter();

    interpreter.run(input, output);
    output = output.reshape([192]);

    predictedArray = List.from(output);

    // if (!loginUser) {
    //   LocalDB.setUserDetails(User(name: name, array: predictedArray!));
    //   print("@@@@@@@@@@@@ array: $predictedArray @@@@@@@@@@ ");
    //   return null;
    // } else {
    //   User? user = LocalDB.getUser();
    //   List userArray = user.array!;
    //   double threshold = 1.5;
    //   var dist = euclideanDistance(predictedArray!, userArray);
    //   if (dist <= threshold) {
    //     return user;
    //   } else {
    //     return null;
    //   }
    // }
  }

  double euclideanDistance(List l1, List l2) {
    double sum = 0;
    for (int i = 0; i < l1.length; i++) {
      sum += pow((l1[i] - l2[i]), 2);
    }
    return sqrt(sum);
  }

  Future<void> initializeInterpreter() async {
    Delegate? delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
            allowPrecisionLoss: true,
          ),
        );
      }
      // var interpreterOptions = InterpreterOptions()..addDelegate(delegate!);
      //
      // interpreter = await Interpreter.fromAsset('mobilefacenet.tflite', options: interpreterOptions);

      interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite');
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  Future<List> _preProcess(InputImage inputImage, Face faceDetected) async {
    imglib.Image croppedImage = await _cropFace(inputImage, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, size: 112);

    Float32List imageAsList = _imageToByteListFloat32(img);
    return imageAsList;
  }

  Future<imglib.Image> _cropFace(InputImage inputImage, Face faceDetected) async {
    imglib.Image convertedImage = await decodeYUV420SP(inputImage);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(convertedImage, x: x.round(), y: y.round(), width: w.round(), height: h.round());
  }

  // Future<imglib.Image> _convertInputImage(InputImage inputImage) async {
  //   final ByteData? byteData = await inputImage.inputImageData?.buffer;
  //   final Uint8List imageBytes = byteData!.buffer.asUint8List();
  //   return imglib.decodeImage(imageBytes)!;
  // }

  imglib.Image decodeYUV420SP(InputImage image) {
    final width = image.metadata!.size.width.toInt();
    final height = image.metadata!.size.height.toInt();

    Uint8List yuv420sp = image.bytes!;
    var rotationOfCamera = 0;
    if (image.metadata != null && image.metadata!.rotation.rawValue != 0) {
      rotationOfCamera = image.metadata!.rotation.rawValue;
    }
    return decodeYUV420SP_from_camera(
        width, height, yuv420sp, rotationOfCamera);
  }


  imglib.Image decodeYUV420SP_from_camera(
      int width, int height, Uint8List yuv420sp, int rotationOfCamera) {
    var outImg =
    imglib.Image(width: width, height: height); // default numChannels is 3

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
    return outImg;  }

  Float32List _imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (pixel.r - 128) / 128;
        buffer[pixelIndex++] = (pixel.g - 128) / 128;
        buffer[pixelIndex++] = (pixel.b - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }
}
