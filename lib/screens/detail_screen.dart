// ignore_for_file: import_of_legacy_library_into_null_safe


import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moviesapp/bloc/get_movie_video_bloc.dart';
import 'package:moviesapp/model/movie.dart';
import 'package:moviesapp/model/video.dart';
import 'package:moviesapp/model/video_response.dart';
import 'package:moviesapp/screens/video_play_screen.dart';
import 'package:moviesapp/style/theme.dart' as Style;
import 'package:moviesapp/widget/casts.dart';
import 'package:moviesapp/widget/movie_info.dart';
import 'package:moviesapp/widget/similar_movies.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  DetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(movie);
}

class _DetailScreenState extends State<DetailScreen> {
  final Movie movie;
  _DetailScreenState(this.movie);
  @override
  void initState() {
    super.initState();
      movieVideos..getVideos(movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideos..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Builder(
        builder: (context) {
          return SliverFab(
            floatingPosition: FloatingPosition(right: 20),
            floatingWidget: StreamBuilder<VideoResponse>(
              stream: movieVideos.subject.stream,
              builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data?.error != null &&
                      snapshot.data!.error.length > 0) {
                    return _buildErrorWidgets(snapshot.data?.error);
                  }
                  return _buildVideoWidgets(snapshot.data!);
                } else if (snapshot.hasError) {
                  return _buildErrorWidgets(snapshot.error);
                } else {
                  return _buildLoadingWidget();
                }
              },
            ),
            expandedHeight: 200.0,
            slivers: <Widget>[
              new SliverAppBar(
                backgroundColor: Style.Colors.mainColor,
                expandedHeight: 200.0,
                pinned: true,
                flexibleSpace: new FlexibleSpaceBar(
                    title: Text(
                      movie.title.length > 40
                          ? movie.title.substring(0, 37) + "..."
                          : movie.title,
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.normal),
                    ),
                    background: Stack(
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/original/" +
                                        movie.backPoster)),
                          ),
                          child: new Container(
                            decoration: new BoxDecoration(
                                color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: [
                                  0.1,
                                  0.9
                                ],
                                colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.black.withOpacity(0.0)
                                ]),
                          ),
                        ),
                      ],
                    )),
              ),
              SliverPadding(
                  padding: EdgeInsets.all(0.0),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            movie.rating.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          RatingBar(
                            itemSize: 10.0,
                            initialRating: movie.rating / 2,
                            ratingWidget: RatingWidget(
                              empty: Icon(
                                EvaIcons.star,
                                color: Style.Colors.secondaryColor,
                              ),
                              full: Icon(
                                EvaIcons.star,
                                color: Style.Colors.secondaryColor,
                              ),
                              half: Icon(
                                EvaIcons.star,
                                color: Style.Colors.secondaryColor,
                              ),
                            ),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Text(
                        "OVERVIEW",
                        style: TextStyle(
                            color: Style.Colors.titleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        movie.overview,
                        style: TextStyle(
                            color: Colors.white, fontSize: 12.0, height: 1.5),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    MovieInfo(
                      id: movie.id,
                    ),
                    Casts(
                      id: movie.id,
                    ),
                    SimilarMovies(id: movie.id)
                  ])))
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorWidgets(error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(' ERROR OCCURED  ',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Colors.red.shade50)),
        ],
      ),
    );
  }

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

  Widget _buildVideoWidgets(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
        backgroundColor: Style.Colors.secondaryColor,
        child: Icon(
          Icons.play_arrow,
          size: 20,
        ),
        onPressed: () {
          Navigator.push(
              this.context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                      controller: YoutubePlayerController(
                          initialVideoId: videos[0].key,
                          flags: YoutubePlayerFlags(
                            controlsVisibleAtStart: true,
                            autoPlay: true,
                          )))));
        });
  }
}
