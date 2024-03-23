import 'package:flutter/material.dart';
import 'HomePageVids.dart';
import '../FavVids/FavoriteMoviesPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Search/SearchedMoviesPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedSort;
  final List<String> list = ['Years', 'Rating']; // Define list here
  List<Movie> favoriteMovies = [];
  TextEditingController _searchController = TextEditingController();
  List<SearchMovie> _searchResults = []; 

  @override
  void initState() {
    super.initState();
    _selectedSort = list.first; // Set initial value for _selectedSort
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.grey),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              prefixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed:
                    _search, // Call _search function when icon is clicked
              ),
            ),
            onChanged: (value) {
              // Perform live search as the user types
              // You can add search functionality here as well
            },
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to the favorites page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoriteMoviesPage(favoriteMovies: favoriteMovies),
                ),
              );
            },
            icon: Icon(Icons.favorite),
            label: Text('Favorites'),
          ),
          SizedBox(width: 8),
          DropdownButton<String>(
            value: _selectedSort,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSort = newValue;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            underline: Container(),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              HomePageVids(
                selectedSort: _selectedSort!,
                onFavorite: (movie) {
                  setState(() {
                    if (movie.isFavorite) {
                      favoriteMovies.add(movie);
                      // print('Added to favorites: ${movie.title} (IMDb ID: ${movie.imdbId})');
                    } else {
                      favoriteMovies.removeWhere(
                          (element) => element.imdbId == movie.imdbId);
                      // print('Removed from favorites: ${movie.title} (IMDb ID: ${movie.imdbId})');
                    }
                  });
                },
              ),
            ]),
          )
        ],
      ),
    );
  }

  void _search() async {
    String query = _searchController.text.trim(); // Trim whitespace
    // Check if query is not empty
    print('Search query: $query');
    try {
      final response = await http.get(
        Uri.parse(
            'http://www.omdbapi.com/?apikey=b9d43b38&t=$query'), // Use 't' for single movie search
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
            print(" Movie Results - $jsonData");

        if (jsonData['Response'] == 'True') {
          print("Movie found");
          setState(() {
            _searchResults = [SearchMovie.fromJson(jsonData)];
          });

          // Navigate to SearchedMoviesPage with search results
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SearchedMoviesPage(searchResults: _searchResults),
            ),
          );
        } else {
          print("Movie not found");
          setState(() {
            _searchResults = [];
          });
        }
      } else {
        print('Failed to load search results: ${response.statusCode}');
        // Display user-friendly error message
      }
    } catch (e) {
      print('Error occurred while fetching search results: $e');
      // Display user-friendly error message
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
