import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

class CardDetailPage extends StatefulWidget {
  final String letter;
  const CardDetailPage({Key? key, required this.letter}) : super(key: key);

  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> {
  late VideoPlayerController _controller;
  bool _dataLoaded = false;
  String _description = '';
  String _videoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadDataFromSupabase();
  }

  Future<void> _loadDataFromSupabase() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('kamus')
          .select('video_url, description')
          .eq('title', widget.letter)
          .single();

      final url = response['video_url'] ?? '';
      _description = response['description'] ?? '';

      if (url.isNotEmpty) {
        _videoUrl = url;
        _controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrl));
        await _controller.initialize();

        setState(() {
          _dataLoaded = true;
        });

        _controller.play();
      } else {
        print('Video URL kosong untuk huruf ${widget.letter}');
      }
    } catch (e) {
      print('Gagal memuat data dari Supabase: $e');
    }
  }

  @override
  void dispose() {
    if (_dataLoaded) {
      _controller.dispose();
    }
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
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () {
                        _controller.seekTo(Duration.zero);
                        _controller.play();
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Putar Ulang"),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
