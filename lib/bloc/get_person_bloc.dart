import 'package:moviesapp/model/person_response.dart';
import 'package:moviesapp/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class PersonListBlock {
  final MovieRepository _repository = MovieRepository();
  final BehaviorSubject<PersonResponse> _subject =
      BehaviorSubject<PersonResponse>();

  getPersons() async {
    PersonResponse response = await _repository.getPersons();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }
    BehaviorSubject<PersonResponse> get subject => _subject;
}

final personsBloc = PersonListBlock();
