import 'package:flutter/material.dart';
import 'favorite_screen.dart';
import 'amiibo_detail_screen.dart';
import 'api_service.dart';
import 'amiibo.dart';
import 'local_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<Amiibo> amiibos = [];
  Set<String> favoriteIds = Set<String>();  // Menyimpan ID favorit

  @override
  void initState() {
    super.initState();
    fetchAmiibos();
    _loadFavorites(); // Memuat favorite dari local storage
  }

  Future<void> fetchAmiibos() async {
    final data = await ApiService.fetchAmiibos();
    setState(() {
      amiibos = data;
      isLoading = false;
    });
  }

  // Fungsi untuk memuat data favorit dari local storage
  Future<void> _loadFavorites() async {
    final favorites = await LocalStorage.getFavorites();
    setState(() {
      favoriteIds = Set<String>.from(favorites.map((amiibo) => amiibo.name)); // Menyimpan ID yang difavoritkan
    });
  }

  // Fungsi untuk menambah ke favorit (tanpa menghapus)
  void _addFavorite(Amiibo amiibo) async {
    if (!favoriteIds.contains(amiibo.name)) {
      await LocalStorage.addFavorite(amiibo);
      setState(() {
        favoriteIds.add(amiibo.name); // Menambah ke favorit
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],  // Warna pink untuk AppBar
        title: Text('Nintendo Amiibo', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: amiibos.length,
              itemBuilder: (context, index) {
                final amiibo = amiibos[index];
                bool isFavorite = favoriteIds.contains(amiibo.name); // Cek apakah item ini favorit
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Margin antar item
                  decoration: BoxDecoration(
                    color: Colors.white, // Latar belakang putih
                    borderRadius: BorderRadius.circular(12), // Sudut bulat
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Posisi bayangan
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(amiibo.image, width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(
                      amiibo.name,
                      style: TextStyle(color: Colors.pink[600], fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      amiibo.gameSeries,
                      style: TextStyle(color: Colors.pink[400]),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.pink[300],  // Merah jika favorit
                      ),
                      onPressed: () => _addFavorite(amiibo),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AmiiboDetailScreen(amiibo: amiibo),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.pink[100],  // Warna pink untuk bottom nav
        selectedItemColor: Colors.pink[600],  // Warna pink lebih gelap untuk item yang dipilih
        unselectedItemColor: Colors.pink[300],  // Warna pink lebih terang untuk item yang tidak dipilih
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoriteScreen()),
            );
          }
        },
      ),
    );
  }
}
