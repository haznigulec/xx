import 'package:piapiri_v2/theme/theme_context_extension.dart';
import 'package:piapiri_v2/common/widgets/place_holder/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/common/widgets/common_widgets/ink_wrapper.dart';
import 'package:piapiri_v2/common/widgets/progress_indicators/shimmerize.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MarketYoutubePlayerWidget extends StatefulWidget {
  final String embedCode;
  final double height;
  final Function() onLodingCompleted;

  const MarketYoutubePlayerWidget({
    super.key,
    required this.embedCode,
    this.height = 200,
    required this.onLodingCompleted,
  });

  @override
  State<MarketYoutubePlayerWidget> createState() => _MarketYoutubePlayerWidgetState();
}

class _MarketYoutubePlayerWidgetState extends State<MarketYoutubePlayerWidget> {
  late YoutubePlayerController _controller;
  late String? _videoId;
  bool _thumbnailLoaded = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoId = _extractVideoId(widget.embedCode);
    _controller = YoutubePlayerController(
      initialVideoId: _videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: false,
        hideControls: false,
        disableDragSeek: false,
      ),
    )..addListener(_videoListener);
  }

  _videoListener() {
    if (_controller.value.isReady) {
      final playerState = _controller.value.playerState;
      if (playerState == PlayerState.ended && _isPlaying) {
        _controller.reset();
        setState(() => _isPlaying = false);
      }
    }
  }

  String? _extractVideoId(String embedCode) {
    final regExp = RegExp(r'src="https:\/\/www\.youtube\.com\/embed\/([a-zA-Z0-9_-]+)(?:\?[^"]*)?"');
    final match = regExp.firstMatch(embedCode);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  String get _thumbnailUrl => "https://img.youtube.com/vi/$_videoId/0.jpg";

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) return const SizedBox.shrink();

    return VisibilityDetector(
      key: Key(_videoId!),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0 && _isPlaying) {
          _controller.pause();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: Grid.m - Grid.xs),
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: !_isPlaying
              ? Shimmerize(
                  enabled: !_thumbnailLoaded,
                  child: Container(
                    height: widget.height,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: !_thumbnailLoaded ? context.pColorScheme.lightHigh : context.pColorScheme.transparent,
                      borderRadius: BorderRadius.circular(Grid.m),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          _thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            WidgetsBinding.instance.addPostFrameCallback((_) async {
                              if (!_thumbnailLoaded) {
                                await Future.delayed(const Duration(milliseconds: 500));
                                widget.onLodingCompleted.call();
                                setState(() => _thumbnailLoaded = true);
                              }
                            });
                            return const SizedBox.shrink();
                          },
                          loadingBuilder: (context, child, progress) {
                            if (progress != null) {
                              return const SizedBox.shrink();
                            }
                            WidgetsBinding.instance.addPostFrameCallback((_) async {
                              if (!_thumbnailLoaded) {
                                await Future.delayed(const Duration(milliseconds: 500));
                                widget.onLodingCompleted.call();
                                setState(() => _thumbnailLoaded = true);
                              }
                            });
                            return child;
                          },
                        ),
                        Visibility(
                          visible: _thumbnailLoaded,
                          child: Center(
                            child: InkWrapper(
                              child: SvgPicture.asset(
                                ImagesPath.player,
                                width: Grid.xl,
                                height: Grid.xl,
                                colorFilter: ColorFilter.mode(
                                  context.pColorScheme.lightHigh,
                                  BlendMode.srcIn,
                                ),
                              ),
                              onTap: () {
                                if (mounted) {
                                  setState(() => _isPlaying = true);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: context.pColorScheme.transparent,
                    bottomActions: const [
                      ProgressBar(isExpanded: true),
                      CurrentPosition(),
                      RemainingDuration(),
                      PlaybackSpeedButton(),
                    ],
                  ),
                  builder: (context, player) => player,
                ),
        ),
      ),
    );
  }
}
