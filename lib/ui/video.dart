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
  void deactivate() {
    for (var controller in _controllers) {
      controller.pause(); 
    }
    super.deactivate();
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
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF176), 
        elevation: 4,
        centerTitle: true,
        title: const Text(
          'Video Pembelajaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF424242), 
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/allPage/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          FutureBuilder<List<VideoItem>>(
            future: _videosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Video tidak ditemukan'));
              }

              final videos = snapshot.data!;

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
                          progressIndicatorColor: Colors.amber,
                        ),
                        builder: (context, player) {
                          return Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: player,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 40,
                        left: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            videos[index].title,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
