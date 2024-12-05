import 'package:shared_preferences/shared_preferences.dart';
import 'amiibo.dart';
import 'dart:convert';

class LocalStorage {
  // Menambahkan Amiibo ke dalam favorit
  static Future<void> addFavorite(Amiibo amiibo) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(jsonEncode(amiibo.toJson()));  // Menyimpan data sebagai JSON
    await prefs.setStringList('favorites', favorites);
  }

  // Mengambil daftar favorit
  static Future<List<Amiibo>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    return favorites.map((item) => Amiibo.fromJson(jsonDecode(item))).toList();
  }
}
