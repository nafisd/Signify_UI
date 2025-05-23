import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/video_controller.dart';
import '../models/video_item.dart';

class YouTubeShortsScreen extends StatefulWidget {
  final String genre;
  const YouTubeShortsScreen({required this.genre});

  @override
  _YouTubeShortsScreenState createState() => _YouTubeShortsScreenState();
}

class _YouTubeShortsScreenState extends State<YouTubeShortsScreen> {
  late Future<List<VideoItem>> _videosFuture;
  final List<YoutubePlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _videosFuture = VideoController.fetchVideos(widget.genre);
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  YoutubePlayerController _createController(String videoId) {
    return YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
        controlsVisibleAtStart: false,
        showLiveFullscreenButton: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<VideoItem>>(
        future: _videosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('No videos found'));

          final videos = snapshot.data!;

          // Prepare controllers only once
          if (_controllers.isEmpty) {
            _controllers.addAll(
              videos.map((video) => _createController(video.videoId)),
            );
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final controller = _controllers[index];
              return Stack(
                children: [
                  YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: controller,
                      showVideoProgressIndicator: true,
                    ),
                    builder: (context, player) {
                      return Container(
                        color: Colors.black,
                        child: Center(child: player),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 30,
                    left: 16,
                    right: 16,
                    child: Text(
                      videos[index].title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
