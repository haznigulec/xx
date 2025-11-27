import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:piapiri_v2/common/widgets/bottomsheet/p_bottom_sheet.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p_core/keys/navigator_keys.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/piapiri_loading.dart';
import 'package:video_player/video_player.dart';

class EducationVideoWidget extends StatefulWidget {
  final String videoUrl;
  final bool isVideoExpanded;

  const EducationVideoWidget({
    super.key,
    required this.videoUrl,
    required this.isVideoExpanded,
  });

  @override
  State<EducationVideoWidget> createState() => _EducationVideoWidgetState();
}

class _EducationVideoWidgetState extends State<EducationVideoWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoaded = false;

  // Android için infinite loading çözümü
  bool _wasPlayingBefore = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    if (Platform.isAndroid) {
      _videoPlayerController?.removeListener(_videoListener);
    }
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  _initVideo() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    if (Platform.isAndroid) {
      _videoPlayerController?.addListener(_videoListener);
    }

    try {
      await _videoPlayerController?.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        autoInitialize: true,
        cupertinoProgressColors: ChewieProgressColors(bufferedColor: Colors.black),
        progressIndicatorDelay: Platform.isAndroid ? const Duration(days: 1) : null,
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
      PBottomSheet.showError(
        NavigatorKeys.navigatorKey.currentContext!,
        content: e.toString(),
      );
      return;
    }

    setState(() {
      _isLoaded = true;
    });
  }

  void _videoListener() {
    if (!_videoPlayerController!.value.isPlaying && !_wasPlayingBefore) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          _videoPlayerController!.play();
        },
      );
    }
    _wasPlayingBefore = _videoPlayerController!.value.isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    widget.isVideoExpanded ? _videoPlayerController?.play() : _videoPlayerController?.pause();

    return Padding(
      padding: const EdgeInsets.only(
        top: Grid.m,
      ),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width - Grid.m * 2,
        height: (MediaQuery.sizeOf(context).width - Grid.m * 2) * .57,
        child: !_isLoaded
            ? const PLoading()
            : Chewie(
                controller: _chewieController!,
              ),
      ),
    );
  }
}
