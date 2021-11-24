import 'package:moviesapp/model/video.dart';

class VideoResponse {
  final List<Video> videos;
  String error;

  VideoResponse(this.videos, this.error);
  VideoResponse.fromJson(Map<String, dynamic> json)
      : videos =
            (json["result"] as List).map((i) => Video.fromJson(i)).toList(),
            error="";
  VideoResponse.withError(String errorValue):
    videos=[],
    error=errorValue;
}
