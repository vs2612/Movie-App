import 'package:flutter/material.dart';
import '../HomePage/HomePageVids.dart';

class FavoriteMoviesPage extends StatelessWidget {
  final List<Movie> favoriteMovies;

  const FavoriteMoviesPage({Key? key, required this.favoriteMovies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Movies'),
      ),
      body: ListView.builder(
        itemCount: favoriteMovies.length,
        itemBuilder: (context, index) {
          final movie = favoriteMovies[index];
          return ListTile(
            leading: Image.network(
              movie.imageUrl.first, // Assuming imageUrl is a list of URLs
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            title: Text(movie.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Released: ${movie.released}'),
                Text('IMDB Rating: ${movie.imdbRating}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
