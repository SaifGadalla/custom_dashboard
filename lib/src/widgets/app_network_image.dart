import 'dart:developer';

import 'package:chewie/chewie.dart';
import '../../common.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.color,
    required this.url,
  });

  final String url;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      // child: Image.network(
      //   url,
      //   errorBuilder: (context, error, stackTrace) {
      //     debugPrint('=== IMAGE ERROR ===');
      //     debugPrint('URL: $url');
      //     debugPrint('Error: $error');
      //     debugPrint('StackTrace: $stackTrace');
      //     return Text('$error');
      //   },
      // ),
      child: CachedNetworkImage(
        imageUrl: url,
        cacheKey: url.split('?').first,
        fit: fit,
        height: height,
        width: width,
        color: color,
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
            child: CircularProgressIndicator(value: progress.progress),
          );
        },
        errorWidget: (context, url, error) {
          Logger('image_error').info(error.toString());
          Logger('image_url').info(url);
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(
                  kLogoPath,
                  fit: BoxFit.contain,
                  color: color,
                ),
              ),
              FittedBox(child: AppText(context.l10n.not_found)),
            ],
          );
        },
      ),
    );
  }
}

class AppNetworkVideo extends StatefulWidget {
  final String videoUrl;
  final double? height;
  final double? width;
  const AppNetworkVideo({
    super.key,
    required this.videoUrl,
    required this.height,
    required this.width,
  });

  @override
  State<AppNetworkVideo> createState() => _AppNetworkVideoState();
}

class _AppNetworkVideoState extends State<AppNetworkVideo> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(),
    );
    try {
      await _controller.initialize();
      await _controller.setVolume(0);
      await _controller.setLooping(true);
      await _controller.play();
    } catch (e) {
      log(e.toString());
    }

    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? SizedBox(
            height: widget.height,
            width: widget.width,
            child: VideoPlayer(_controller),
          )
        : const SizedBox();
  }
}

class CustomYoutubePlayer extends StatelessWidget {
  final String videoUrl;
  final double? height;
  final double? width;
  const CustomYoutubePlayer({
    super.key,
    required this.videoUrl,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayerController.convertUrlToId(videoUrl);
    if (videoId == null) return Center(child: CircularProgressIndicator());
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    return YoutubePlayerControllerProvider(
      controller: controller,
      child: SizedBox(
        height: height,
        width: width,
        child: YoutubePlayer(controller: controller),
      ),
    );
  }
}

class CustomAppVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final double? height;
  final double? width;
  const CustomAppVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.height,
    required this.width,
  });

  @override
  State<CustomAppVideoPlayer> createState() => CustomAppVideoPlayerState();
}

class CustomAppVideoPlayerState extends State<CustomAppVideoPlayer> {
  late VideoPlayerController _controller;
  ChewieController? chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      videoPlayerOptions: VideoPlayerOptions(),
    );
    try {
      await _controller.initialize();
      chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: false,
      );
    } catch (e) {
      log(e.toString());
      _hasError = true;
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    chewieController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_hasError) {
      return Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            kLogoPath,
            height: widget.height,
            width: widget.width,
            fit: BoxFit.cover,
          ),
          FittedBox(child: AppText(l10n.not_found)),
        ],
      );
    }
    return chewieController != null &&
            chewieController!.videoPlayerController.value.isInitialized
        ? SizedBox(
            height: widget.height,
            width: widget.width,
            child: Chewie(controller: chewieController!),
          )
        : Center(child: CircularProgressIndicator());
  }
}

class AppVideoLinkPlayer extends StatelessWidget {
  final String videoUrl;
  final double? height;
  final double? width;
  const AppVideoLinkPlayer({
    super.key,
    required this.videoUrl,
    this.height,
    this.width,
  });

  String? extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    if (uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'];
    }

    return null;
  }

  bool isValidYoutubeUrl(String url) {
    final id = extractYoutubeId(url);
    return id != null && id.length == 11;
  }

  bool isYoutubeUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    final host = uri.host.toLowerCase();
    return host.contains('youtube.com') || host.contains('youtu.be');
  }

  Widget _buildErrorWidget(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          kLogoPath,
          height: height,
          width: width,
          fit: BoxFit.fitHeight,
        ),
        FittedBox(child: AppText(l10n.not_found)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isYoutubeUrl(videoUrl)) {
      if (isValidYoutubeUrl(videoUrl)) {
        return CustomYoutubePlayer(
          videoUrl: videoUrl,
          height: height,
          width: width,
        );
      } else {
        return _buildErrorWidget(context);
      }
    }

    // For non-YouTube URLs, check if it's a valid video URL
    final uri = Uri.tryParse(videoUrl);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return _buildErrorWidget(context);
    }

    return CustomAppVideoPlayer(
      videoUrl: videoUrl,
      height: height,
      width: width,
    );
  }
}
