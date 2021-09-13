import 'package:dio/dio.dart';
import 'package:moviesapp/model/genre_response.dart';
import 'package:moviesapp/model/movie_response.dart';
import 'package:moviesapp/model/person_response.dart';

class MovieRepository {
  final String apiKey = '40fce707a99749bc142b40f66884c4a4';
  static final String mainUrl = 'https://api.themoviedb.org/v3';
  final Dio dio = Dio();
  var getPopularUrl = '$mainUrl/movie/top_rated';
  var getMoviesUrl = '$mainUrl/discover/movie/';
  var getPlayingUrl = '$mainUrl/movie/now_playing';
  var getGenresUrl = '$mainUrl/genre/movie/list';
  var getPersonsUrl = '$mainUrl/trending/persons/week';

  Future<MovieResponse> getMovies() async {
    var params = {'api_key': apiKey, 'language': 'en-US', 'page:': 1};
    try {
      Response responses =
          await dio.get(getPopularUrl, queryParameters: params);
      return MovieResponse.fromJson(responses.data);
    } catch (error, stacktrace) {
      print('exception occurred : $error stackTrace : $stacktrace');
      return MovieResponse.withError("$error");
    }
  }

  Future<MovieResponse> getPlayingMovies() async {
    var params = {'api_key': apiKey, 'language': 'en-US', 'page:': 1};
    try {
      Response responses =
          await dio.get(getPlayingUrl, queryParameters: params);
      return MovieResponse.fromJson(responses.data);
    } catch (error, stacktrace) {
      print('exception occurred : $error stackTrace : $stacktrace');
      return MovieResponse.withError("$error");
    }
  }
    Future<GenreResponse> getGenres() async {
    var params = {'api_key': apiKey, 'language': 'en-US', 'page:': 1};
    try {
      Response responses =
          await dio.get(getGenresUrl, queryParameters: params);
      return GenreResponse.fromJson(responses.data);
    } catch (error, stacktrace) {
      print('exception occurred : $error stackTrace : $stacktrace');
      return GenreResponse.withError("$error");
    }
  }
      Future<PersonResponse> getPersons() async {
    var params = {'api_key': apiKey};
    try {
      Response responses =
          await dio.get(getPersonsUrl, queryParameters: params);
      return PersonResponse.fromJson(responses.data);
    } catch (error, stacktrace) {
      print('exception occurred : $error stackTrace : $stacktrace');
      return PersonResponse.withError("$error");
    }
  }
      Future<MovieResponse> getMovieByGenre(int id) async {
    var params = {'api_key': apiKey, 'language': 'en-US','page':1, "with_genres":id};
    try {
      Response responses =
          await dio.get(getGenresUrl, queryParameters: params);
      return MovieResponse.fromJson(responses.data);
    } catch (error, stacktrace) {
      print('exception occurred : $error stackTrace : $stacktrace');
      return MovieResponse.withError("$error");
    }
  }


}
