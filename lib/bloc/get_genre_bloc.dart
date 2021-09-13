import 'package:moviesapp/model/genre_response.dart';
import 'package:moviesapp/repository/repository.dart';
import 'package:rxdart/subjects.dart';

class GenreListBloc {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<GenreResponse> _subject =
      BehaviorSubject<GenreResponse>();

  getGenres() async {
    GenreResponse response = await _repository.getGenres();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GenreResponse> get subject => _subject;
}

final getGenreBloc = GenreListBloc();
