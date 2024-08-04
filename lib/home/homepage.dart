import 'package:facial_emotions/home/view/face_detector_view.dart';
import 'package:facial_emotions/manager/output_management_page.dart';
import 'package:flutter/material.dart';

import '../utils/object_box_manager.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Recognition App'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => FaceDetectorView()));
                      },
                      child: const Text('Emotion Recognition')),

                  Padding(
                    padding: const EdgeInsets.only(top: 28.0),
                    child: TextButton(
                        onPressed: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ObjectBoxQueryPage()));
                        },
                        child: const Text('Emotion Manager')),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


