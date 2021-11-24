import 'package:flutter/material.dart';
import 'package:moviesapp/model/cast_response.dart';
import 'package:moviesapp/model/movie_response.dart';
import 'package:moviesapp/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class SimilarMovieBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();
  getSimilar(int id) async {
    MovieResponse response = await _repository.getSimilarMovie(id);
    _subject.sink.add(response);
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.cast();
  }

  BehaviorSubject<MovieResponse> get subject => _subject;
}

final similarMovie = SimilarMovieBloc();
