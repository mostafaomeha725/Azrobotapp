import 'package:azrobot/core/utils/app_images.dart';
import 'package:azrobot/core/utils/app_text_styles.dart';
import 'package:azrobot/core/widgets/can_pop_widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailsViewBody extends StatelessWidget {
  const VideoDetailsViewBody({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                child: Image.network(
                  item['image_url'] ?? Assets.assetshub,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    Assets.assetshub,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      final youtubeUrl = item['video'];
                      if (youtubeUrl == null || youtubeUrl.isEmpty) {
                        debugPrint('Video URL is empty or null');
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoPlayerScreen(videoUrl: youtubeUrl),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 16,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left_sharp,
                          color: Colors.black, size: 24),
                      onPressed: () => GoRouter.of(context).pop(),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 16,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        Assets.assetsazrobotlogoonly,
                        height: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text('Date: ${item['date'] ?? item['updated_at']}',
                        style:
                            TextStyles.bold12w500.copyWith(color: Colors.grey)),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(item['title'] ?? 'No title available',
                        style: TextStyles.bold24w600),
                  ),
                  const SizedBox(height: 8),
                  if (item['source'] != null)
                    Text(
                      'Source: ${item['source']}',
                      style:
                          TextStyles.bold13w400.copyWith(color: Colors.grey),
                    ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        item['description'] ?? 'No description available',
                        style: TextStyles.bold16w400),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl.toString());
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _controller),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF0062CC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_left_sharp,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                      CanPopWidgets(). handleBackButton(context);
                },
              ),
            ),
          ),
            title: const Text("Video Player",
            style: TextStyles.bold22w600,
            
            ),
            centerTitle: true,
          ),
          body: Center(child: player),
        );
      },
    );
  }
}