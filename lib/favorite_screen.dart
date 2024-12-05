import 'package:flutter/material.dart';
import 'amiibo.dart';
import 'local_storage.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: Text('Favorite Amiibos'),
      ),
      body: FutureBuilder<List<Amiibo>>(
        future: LocalStorage.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite items.'));
          }
          final favorites = snapshot.data!;
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final amiibo = favorites[index];
              return ListTile(
                leading: Image.network(amiibo.image),
                title: Text(amiibo.name),
                subtitle: Text(amiibo.gameSeries),
              );
            },
          );
        },
      ),
    );
  }
}
