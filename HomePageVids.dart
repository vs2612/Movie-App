import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


typedef void FavoriteCallback(Movie movie);

class HomePageVids extends StatefulWidget {
  final String selectedSort;
  final FavoriteCallback onFavorite;

  const HomePageVids(
      {Key? key, required this.selectedSort, required this.onFavorite})
      : super(key: key);

  @override
  _HomePageVidsState createState() => _HomePageVidsState();
}

class _HomePageVidsState extends State<HomePageVids> {
  late List<Movie> movies;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(covariant HomePageVids oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSort != oldWidget.selectedSort) {
      fetchData();
    }
  }

  Future<void> fetchData() async {
    var url = Uri.parse('https://ott-details.p.rapidapi.com/advancedsearch');
    var queryParams = {
      'start_year': '1970',
      'end_year': '2020',
      'min_imdb': '6',
      'max_imdb': '7.8',
      'genre': 'action',
      'language': 'english',
      'type': 'movie',
      'page': '1',
    };

    if (widget.selectedSort == 'Years') {
      queryParams['sort'] = 'latest';
    } else if (widget.selectedSort == 'Rating') {
      queryParams['sort'] = 'highestrated';
    }

    var headers = {
      'X-RapidAPI-Key': '758e0b4cf6msh22d6913a1779903p17747djsn16611e4ab8ad',
      'X-RapidAPI-Host': 'ott-details.p.rapidapi.com'
    };

    try {
      var response = await http.get(url.replace(queryParameters: queryParams),
          headers: headers);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          movies = (responseData['results'] as List)
              .map((movieJson) => Movie.fromJson(movieJson))
              .toList();
          isLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : movies.isEmpty
            ? Center(
                child: Text('No movies found'),
              )
            : Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final movie = movies[index];
                            return ListTile(
                              leading: Image.network(
                                movie.imageUrl.first,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                              title: Row(
                                children: [
                                  Text(movie.title),
                                  SizedBox(width: 8),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        movie.toggleFavorite();
                                        widget.onFavorite(movie);
                                      });
                                    },
                                    icon: Icon(
                                      movie.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          movie.isFavorite ? Colors.red : null,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Released: ${movie.released}'),
                                  Text('IMDB Rating: ${movie.imdbRating}'),
                                ],
                              ),
                            );
                          },
                          childCount: movies.length,
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }
}

class Movie {
  final String imdbId;
  final List<String> imageUrl;
  final String title;
  final int released;
  final double imdbRating;
  bool isFavorite;

  Movie({
    required this.imdbId,
    required this.imageUrl,
    required this.title,
    required this.released,
    required this.imdbRating,
    this.isFavorite = false,
  });
factory Movie.fromJson(Map<String, dynamic> json) {

  var imageUrl = json['imageurl'] != null && json['imageurl'].isNotEmpty
      ? List<String>.from(json['imageurl']) 
      : ['https://toppng.com/uploads/preview/movie-moviemaker-film-cut-svg-png-icon-free-download-movie-icon-11563265487xzdashbdvx.png']; 

  return Movie(
    imdbId: json['imdbid'],
    imageUrl: imageUrl,
    title: json['title'] ?? '',
    released: json['released'] ?? 0,
    imdbRating: json['imdbrating'] != null
        ? double.tryParse(json['imdbrating'].toString()) ?? 0.0
        : 0.0,
  );
}

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

class SearchMovie {
  final String title;
  final String year;
  final String poster;
  final String imdbRating;

  SearchMovie({
    required this.title,
    required this.year,
    required this.poster,
    required this.imdbRating,
  });

  factory SearchMovie.fromJson(Map<String, dynamic> json) {
    return SearchMovie(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      poster: json['Poster'] ?? '',
      imdbRating: json['imdbRating'] ?? '',
    );
  }
}
