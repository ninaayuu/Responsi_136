import 'dart:convert';
import 'package:http/http.dart' as http;
import 'amiibo.dart';

class ApiService {
  static Future<List<Amiibo>> fetchAmiibos() async {
    final response = await http.get(Uri.parse('https://www.amiiboapi.com/api/amiibo/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['amiibo'];
      return data.map((json) => Amiibo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load amiibos');
    }
  }
}
