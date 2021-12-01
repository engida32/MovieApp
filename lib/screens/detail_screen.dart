import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moviesapp/bloc/get_movie_video_bloc.dart';
import 'package:moviesapp/bloc/get_movies_bloc.dart';
import 'package:moviesapp/model/movie.dart';
import 'package:moviesapp/model/movie_response.dart';
import 'package:moviesapp/model/video.dart';
import 'package:moviesapp/model/video_response.dart';
import 'package:moviesapp/style/theme.dart' as Style;
import 'package:sliver_fab/sliver_fab.dart';

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
      body: Builder(builder: (context) {
        return SliverFab(
          floatingPosition: FloatingPosition(left: 20),
          floatingWidget: StreamBuilder<VideoResponse>(
            stream: movieVideos.subject.stream,
            builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.error != null &&
                    snapshot.data!.error.length > 0) {
                  return _buildErrorWidgets(snapshot.data!.error);
                }
                return _buildVideoWidgets(snapshot.data!);
              } else if (snapshot.hasError) {
                return _buildErrorWidgets(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            },
          ),
          expandedHeight: 200,
          slivers: [
            SliverAppBar(
              backgroundColor: Style.Colors.mainColor,
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  movie.title.length > 40
                      ? movie.title.substring(0, 37) + "..."
                      : movie.title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                background: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/original/" +
                                  movie.backPoster),
                          fit: BoxFit.cover,
                        )),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0)
                      ])))
                ]),
              ),
            ),
            SliverPadding(
                padding: EdgeInsets.all(0),
                sliver: SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(movie.rating.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 5),
                                              RatingBar.builder(
                          itemSize: 10,
                          initialRating: movie.rating / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 3),
                          wrapAlignment: WrapAlignment.start,
                          itemBuilder: (context, _) => Icon(EvaIcons.star,
                              color: Style.Colors.secondaryColor,size: 12,),
                          glowColor: Colors.amber,
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    ),
                  )
                ])))
          ],
        );
      }),
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

  Widget _buildVideoWidgets(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
        backgroundColor: Style.Colors.secondaryColor,
        child: Icon(Icons.play_arrow),
        onPressed: () {});
  }
}
