import 'package:moviesapp/model/cast.dart';

class CastResponse {
  List<Cast> casts;
  String error;

  CastResponse(this.casts, this.error);
  CastResponse.fromJson(Map<String, dynamic> json)
      : casts =
            (json['casts'] as List).map((e) => new Cast.fromJson(e)).toList(),
        error = '';
  CastResponse.withError(String errorValue)
  :casts =[],
  error =errorValue;
}
