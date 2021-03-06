import 'package:flutter/material.dart';
import 'package:moviesapp/model/video_response.dart';
import 'package:moviesapp/repository/repository.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rxdart/rxdart.dart';

class MovieVideoBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<VideoResponse> _subject =
      BehaviorSubject<VideoResponse>();
  getVideos(int id) async {
    VideoResponse response = await _repository.getMovieVideo(id);
    _subject.sink.add(response);
  }

  void drainStream() async{
      await _subject.drain();

    }

   @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }
  BehaviorSubject<VideoResponse> get subject => _subject;
}

final movieVideos = MovieVideoBloc();
