import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CardDetailPage extends StatefulWidget {
  final String letter;
  const CardDetailPage({Key? key, required this.letter}) : super(key: key);

  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  late VideoPlayerController _controller;
  Timer? _stopTimer;

  // Dummy segment data
  final Map<String, Map<String, Duration>> _segments = {
    'A': {'start': Duration(seconds: 0), 'end': Duration(seconds: 2)},
    'B': {'start': Duration(seconds: 2), 'end': Duration(seconds: 4)},
    'C': {'start': Duration(seconds: 4), 'end': Duration(seconds: 6)},
    'D': {'start': Duration(seconds: 6), 'end': Duration(seconds: 8)},
    'E': {'start': Duration(seconds: 8), 'end': Duration(seconds: 10)},
    'F': {'start': Duration(seconds: 10), 'end': Duration(seconds: 12)},
    'G': {'start': Duration(seconds: 12), 'end': Duration(seconds: 14)},
    'H': {'start': Duration(seconds: 14), 'end': Duration(seconds: 16)},
  };

  @override
  void initState() {
    super.initState();
    final start = _segments[widget.letter]!['start']!;
    final end = _segments[widget.letter]!['end']!;
    _controller = VideoPlayerController.asset('assets/videos/kamus_isyarat.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.seekTo(start);
        _controller.play();

        _stopTimer = Timer(end - start, () {
          _controller.pause();
        });
      });
  }

  @override
  void dispose() {
    _stopTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Huruf ${widget.letter}'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
