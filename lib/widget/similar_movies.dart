import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:moviesapp/bloc/get_movie_similar_bloc.dart';
import 'package:moviesapp/model/movie.dart';
import 'package:moviesapp/model/movie_response.dart';
import 'package:moviesapp/style/theme.dart' as Style;

class SimilarMovies extends StatefulWidget {
  final int id;
  const SimilarMovies({Key? key, required this.id}) : super(key: key);

  @override
  _SimilarMoviesState createState() => _SimilarMoviesState(id);
}

class _SimilarMoviesState extends State<SimilarMovies> {
  final int id;
  _SimilarMoviesState(this.id);
  @override
  void initState() {
    super.initState();
    similarMovie..getSimilar(id);
  }

  @override
  void dispose() {
    super.dispose();
    similarMovie.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "Similar  Movies ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 5),
        StreamBuilder<MovieResponse>(
            stream: similarMovie.subject.stream,
            builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.error != null &&
                    snapshot.data!.error.length > 0) {
                  return _buildErrorWidgets(snapshot.data?.error);
                }
                return buildMoviesWidget(snapshot.data!);
              } else if (snapshot.hasError) {
                return _buildErrorWidgets(snapshot.error);
              } else {
                return _buildLoadingWidget();
              }
            })
      ],
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

  Widget buildMoviesWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        child: Text(
          " No Movies ",
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      );
    } else {
      return Container(
        height: 270,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    movies[index].poster == null
                        ? Container(
                            height: 180,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Style.Colors.secondaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                shape: BoxShape.rectangle),
                            child: Column(
                              children: [
                                Icon(EvaIcons.filmOutline,
                                    color: Colors.white, size: 50)
                              ],
                            ),
                          )
                        : Container(
                            width: 180,
                            height: 175,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w200/" +
                                        movies[index].poster),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 180,
                      child: Text(
                        movies[index].title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          movies[index].rating.toString(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            inherit: true,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                          width: 5,
                        ),
                        RatingBar.builder(
                          itemSize: 8,
                          initialRating: movies[index].rating / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 3),
                          wrapAlignment: WrapAlignment.start,
                          itemBuilder: (context, _) => Icon(
                            EvaIcons.star,
                            color: Style.Colors.secondaryColor,
                            size: 12,
                          ),
                          glowColor: Colors.amber,
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            }),
      );
    }
  }
}
