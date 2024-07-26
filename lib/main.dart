import 'package:facial_emotions/home/face_detector_model.dart';
import 'package:facial_emotions/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/object_box_manager.dart';


Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  // await HiveBoxes.initialize();

  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo ObjectBox và mở store
  var objectBoxManager = ObjectBoxManager();
  await objectBoxManager.open();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FaceDetectorViewModel(objectBoxManager: objectBoxManager)),
        Provider<ObjectBoxManager>(create: (_) => objectBoxManager),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}