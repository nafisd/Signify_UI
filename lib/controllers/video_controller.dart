import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video_item.dart';

class VideoController {
  static const String _apiKey = 'AIzaSyDM5LQcufwplPK-DFtVz3LRpa6FBYSXKT4';

  static Future<List<VideoItem>> fetchVideos(String genre) async {
    final String url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&videoDuration=short&q=$genre&maxResults=20&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception('Failed to fetch videos');

    final data = json.decode(response.body);
    List items = data['items'];

    return items.map((item) {
      final videoId = item['id']['videoId'];
      final snippet = item['snippet'];
      return VideoItem(
        videoId: videoId,
        title: snippet['title'],
        thumbnailUrl: snippet['thumbnails']['medium']['url'],
      );
    }).toList();
  }
}
