import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  String _description = '';
  Duration _start = Duration.zero;
  Duration _end = Duration.zero;
  bool _dataLoaded = false;

  Future<void> _loadLetterData() async {
    final jsonStr = await rootBundle.loadString('assets/kamusDetails/kamus_letter.json');
    final Map<String, dynamic> data = json.decode(jsonStr);
    final letterData = data[widget.letter];

    if (letterData != null) {
      _start = Duration(seconds: letterData['start']);
      _end = Duration(seconds: letterData['end']);
      _description = letterData['description'];

      _controller = VideoPlayerController.asset('assets/kamusDetails/Kamus_isyarat.mp4');
      await _controller.initialize();

      setState(() {
        _dataLoaded = true;
      });

      _controller.seekTo(_start);
      _controller.play();

      _stopTimer = Timer(_end - _start, () {
        _controller.pause();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLetterData();
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
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Detail Huruf ${widget.letter}',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _dataLoaded
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.letter,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _description,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                      ),
                      onPressed: () {
                        _controller.seekTo(_start);
                        _controller.play();
                        _stopTimer?.cancel();
                        _stopTimer = Timer(_end - _start, () {
                          _controller.pause();
                        });
                      },
                      icon: Icon(Icons.play_arrow),
                      label: Text("Putar Ulang"),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
