import 'package:chewie/chewie.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/circle_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class PVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const PVideoPlayer({super.key, required this.videoUrl});

  @override
  State<PVideoPlayer> createState() => _PVideoPlayerState();
}

class _PVideoPlayerState extends State<PVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  bool isLoaded = false;

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  Future<dynamic> _initVideo() async {
    videoPlayerController = VideoPlayerController.networkUrl(
      httpHeaders: {
        'AccessKey': '62f73103-d83f-430c-a3df4ca34aad-3f05-4565', // AppConfig cdnKey e taşınacak.
      },
      Uri.parse(
        widget.videoUrl,
      ),
    );

    try {
      await videoPlayerController?.initialize();
      videoPlayerController?.play();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        autoInitialize: true,
        cupertinoProgressColors: ChewieProgressColors(bufferedColor: Colors.black),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          );
        },
      );
    } catch (e) {
      return PBottomSheet.showError(NavigatorKeys.navigatorKey.currentContext ?? context, content: e.toString());
    }

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return !isLoaded
        ? const PCircularProgressIndicator()
        : Chewie(
            controller: chewieController!,
          );
  }
}
