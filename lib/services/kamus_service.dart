import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<dynamic>> fetchKamusDataFromSupabase() async {
  final supabase = Supabase.instance.client;
  final response = await supabase
      .from('kamus') // nama tabel
      .select('title, image_url')
      .order('title', ascending: true);
  return response;
}
  