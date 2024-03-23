import 'package:flutter/material.dart';
import 'package:movie_app/HomePage/HomePageVids.dart';

class SearchedMoviesPage extends StatelessWidget {
  final List<SearchMovie> searchResults;

  const SearchedMoviesPage({Key? key, required this.searchResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          var movie = searchResults[index];
          return ListTile(
            title: Text(movie.title),
            subtitle: Text('Year: ${movie.year} | IMDb Rating: ${movie.imdbRating}'),
            leading: movie.poster != 'N/A'
                ? Image.network(
                    movie.poster,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey, // Placeholder for missing poster
                  ),
          
          );
        },
      ),
    );
  }
}
