import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../utils/object_box_manager.dart';
import '../face_detector_model.dart';

class VideoPlayerView extends StatefulWidget {
  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late FlickManager flickManager;
  bool _isPlaying = false;
  bool _isEnded = false;

  late FaceDetectorViewModel faceDetectorViewModel;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.asset("assets/short_video.mp4"),
    );

    addListener();
  }

  void initViewModel() {
    // Khởi tạo FaceDetectorViewModel từ Provider hoặc truyền vào từ parent widget
    faceDetectorViewModel = FaceDetectorViewModel(objectBoxManager: ObjectBoxManager());
  }

  void addListener() {
    flickManager.flickVideoManager?.videoPlayerController?.addListener(_videoListener);
  }

  void removeListener() {
    flickManager.flickVideoManager?.videoPlayerController?.removeListener(_videoListener);
  }

  void _videoListener() {
    final isPlaying = flickManager.flickVideoManager?.videoPlayerController?.value.isPlaying ?? false;
    final isBuffering = flickManager.flickVideoManager?.videoPlayerController?.value.isBuffering ?? false;
    final isEnded = flickManager.flickVideoManager?.videoPlayerController?.value.position ==
        flickManager.flickVideoManager?.videoPlayerController?.value.duration;

    if (isPlaying && !_isPlaying && !isBuffering) {
      // Hành động khi video bắt đầu phát
      _isPlaying = true;
      print('Video đang phát');
      onPlay();
    } else if (!isPlaying && _isPlaying && !isBuffering) {
      // Hành động khi video tạm dừng
      _isPlaying = false;
      print('Video đã tạm dừng');
      onPause();
    }

    if (isEnded && !_isEnded) {
      // Hành động khi video kết thúc
      _isPlaying = false;
      _isEnded = true;
      print('Video đã kết thúc');
      onEnd();
    }
  }

  void onPlay() {
    // Thực hiện hành động khi video bắt đầu phát
    print('Hành động khi video bắt đầu phát');
    initViewModel();
  }

  void onPause() {
    // Thực hiện hành động khi video tạm dừng
    print('Hành động khi video tạm dừng');
  }

  void onEnd() {
    // Thực hiện hành động khi video kết thúc
    print('Hành động khi video kết thúc');
    var viewModel = Provider.of<FaceDetectorViewModel>(context, listen: false);
    List<List<double>?> arrEmo = viewModel.arrEmo;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    faceDetectorViewModel.saveEmotionData("short_video", formattedDate, arrEmo);
  }


  @override
  void didUpdateWidget(VideoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      removeListener();
      addListener();
    }
  }

  @override
  void dispose() {
    removeListener();
    flickManager.dispose();
    super.dispose();
    if(_isEnded){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlickVideoPlayer(
        flickManager: flickManager,
      ),
    );
  }
}

