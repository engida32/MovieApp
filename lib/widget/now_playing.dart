import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moviesapp/bloc/get_now_playing_bloc.dart';
import 'package:moviesapp/model/movie.dart';
import 'package:moviesapp/model/movie_response.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:page_indicator/page_indicator.dart';
import 'package:moviesapp/style/theme.dart' as Style;
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../screens/video_play_screen.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({Key? key}) : super(key: key);

  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  void initState() {
    super.initState();
    nowplayingMovieBloc.getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
        stream: nowplayingMovieBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.error != null &&
                snapshot.data!.error.length > 0) {
              return _buildErrorWidgets(snapshot.data?.error);
            }
            return _buildNowPlayingWidget(snapshot.data!);
          } else if (snapshot.hasError) {
            return _buildErrorWidgets(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        });
  }

  // Widget _Shimmereffect() {
  //   return SizedBox(
  //     width: 200.0,
  //     height: 100.0,
  //     child: Shimmer.fromColors(
  //         baseColor: Color.fromARGB(255, 187, 133, 133),
  //         highlightColor: Color.fromARGB(255, 153, 150, 118),
  //         child: Container(
  //             child: Text(
  //               'Loading...',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: 40.0,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //            )),
  //   );
  // }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 4.0,
          ),
        )
      ],
    ));
  }

  Widget _buildNowPlayingWidget(MovieResponse data) {
    List<Movie> movies = data.movies;

    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('No movies')],
        ),
      );
    } else {
      return Stack(children: [
        Container(
          height: 220,
          child: PageIndicatorContainer(
            align: IndicatorAlign.bottom,
            indicatorSpace: 8,
            padding: EdgeInsets.all(8),
            indicatorColor: Style.Colors.titleColor,
            indicatorSelectorColor: Style.Colors.secondaryColor,
            shape: IndicatorShape.circle(size: 8),
            pageView: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movies.take(5).length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 229,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original/" +
                                      movies[index].backPoster),
                              fit: BoxFit.cover,
                            )),
                      ),
                      Positioned(
                          bottom: 30.0,
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            width: 250.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  movies[index].title,
                                  style: TextStyle(
                                      height: 1.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                          )),
                    ],
                  );
                }),
            length: movies.take(5).length,
          ),
        ),
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Style.Colors.mainColor.withOpacity(1),
                      Style.Colors.mainColor.withOpacity(0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0, 9]))),
        Positioned(
          bottom: 0,
          top: 0,
          left: 0,
          right: 0,
          child: Icon(
            FontAwesomeIcons.playCircle,
            color: Style.Colors.secondaryColor,
            size: 40,
          ),
          //          onPressed: () {
          // Navigator.push(
          //     this.context,
          //     MaterialPageRoute(
          //         builder: (context) => VideoPlayerScreen(
          //             controller: YoutubePlayerController(
          //                 initialVideoId: videos[0].key,
          //                 flags: YoutubePlayerFlags(
          //                   controlsVisibleAtStart: true,
          //                   autoPlay: true,
          //                   isLive: false,
          //                 )))));
          //}
          //)
        ),
      ]);
    }
  }

  Widget _buildErrorWidgets(error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error Occured ',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Colors.red.shade50)),
        ],
      ),
    );
  }
}
