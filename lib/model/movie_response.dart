import 'package:moviesapp/model/movie.dart';
import 'package:moviesapp/model/video.dart';
class MovieResponse {
  final List<Movie> movies;
  // final List<Video> videos;
  final String error;
  MovieResponse(
//    this.videos,
    this.movies,
    this.error,
  );
  MovieResponse.fromJson(Map<String, dynamic> json)
      : movies = (json["results"] as List)
            .map((i) => new Movie.fromJson(i))
            .toList(),
        error = "";

        

  MovieResponse.withError(String errorValue)
      : movies = [],
        error = errorValue;
}
