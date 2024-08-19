import 'package:facial_emotions/home/view/face_detector_view.dart';
import 'package:facial_emotions/manager/output_management_page.dart';
import 'package:flutter/material.dart';

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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaceDetectorView(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/play_button.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        const Text('Emotion Recognition'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 38.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObjectBoxQueryPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/statistics_button.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 8),
                          const Text('Emotion Manager'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
