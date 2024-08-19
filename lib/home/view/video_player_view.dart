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
  //var duration;

  late FaceDetectorViewModel faceDetectorViewModel;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.asset("assets/videos/cat_video.mp4"),
    );

    addListener();

    // // Lắng nghe sự kiện khi video được khởi tạo xong
    // flickManager.flickVideoManager?.videoPlayerController?.initialize().then((_) {
    //   duration = flickManager.flickVideoManager?.videoPlayerController?.value.duration;
    //   print("Thời lượng video: ${duration?.inSeconds} giây");
    // });
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
      _isPlaying = true;
      print('Video đang phát');
      onPlay();
    } else if (!isPlaying && _isPlaying && !isBuffering) {
      _isPlaying = false;
      print('Video đã tạm dừng');
      onPause();
    }

    if (isEnded && !_isEnded) {
      _isPlaying = false;
      _isEnded = true;
      print('Video đã kết thúc');
      onEnd();
    }
  }

  void onPlay() {
    print('Hành động khi video bắt đầu phát');
    initViewModel();
  }

  void onPause() {
    print('Hành động khi video tạm dừng');
  }

  void onEnd() {
    print('Hành động khi video kết thúc');
    var viewModel = Provider.of<FaceDetectorViewModel>(context, listen: false);
    List<List<double>?> arrEmo = viewModel.arrEmo;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    faceDetectorViewModel.saveEmotionData("Cat_video", formattedDate, arrEmo);
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
        flickVideoWithControls: const FlickVideoWithControls(
          videoFit: BoxFit.contain, // Đảm bảo video không bị cắt
          controls: FlickPortraitControls(),
        ),
      ),
    );
  }
}