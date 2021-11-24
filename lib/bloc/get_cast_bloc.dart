import 'package:flutter/material.dart';
import 'package:moviesapp/model/cast_response.dart';
import 'package:moviesapp/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class CastBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<CastResponse> _subject =
      BehaviorSubject<CastResponse>();
  getCast(int id) async {
    CastResponse response = await _repository.getCasts(id);
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

  BehaviorSubject<CastResponse> get subject => _subject;
}

final castBloc = CastBloc();
