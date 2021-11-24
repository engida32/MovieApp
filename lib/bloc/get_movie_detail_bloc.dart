import 'package:flutter/material.dart';
import 'package:moviesapp/model/movie_detail_response.dart';
import 'package:moviesapp/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieDetailResponse> _subject =
      BehaviorSubject<MovieDetailResponse>();
  getDetail(int id) async {
    MovieDetailResponse response = await _repository.getMovieDetail(id);
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

  BehaviorSubject<MovieDetailResponse> get subject => _subject;
}

final detailBloc = MovieDetailBloc();
