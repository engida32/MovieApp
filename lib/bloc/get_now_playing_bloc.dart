import 'package:moviesapp/model/movie_response.dart';
import 'package:moviesapp/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class NowPlayingListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<MovieResponse> _subject =
      BehaviorSubject<MovieResponse>();

  getNowPlaying() async {
    MovieResponse response = await _repository.getPlayingMovies();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }
}

final nowplayingMovieBloc = NowPlayingListBloc();
