import 'package:flutter/material.dart';
import 'package:moviesapp/bloc/get_genre_bloc.dart';
import 'package:moviesapp/model/genre.dart';
import 'package:moviesapp/model/genre_response.dart';
import 'package:moviesapp/widget/genre_list.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  @override
  void initState() {
    super.initState();
    getGenreBloc..getGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
        stream: getGenreBloc.subject.stream,
        builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.error != null &&
                snapshot.data!.error.length > 0) {
              return _buildErrorWidgets(snapshot.data?.error);
            }
            return _buildGenreWidget(snapshot.data!);
          } else if (snapshot.hasError) {
            return _buildErrorWidgets(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        });
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
        children: [
          Text('Error Occured ',style: TextStyle(
            fontSize:15,
            fontWeight: FontWeight.bold
          ),),
        ],
      ),
    );
  }

  Widget _buildGenreWidget(GenreResponse data) {
    List<Genre> genres = data.genres;
    if (genres.length == 0) {
      return Container(
        child: Text('No Genre'),
      );
    } else
      return GenreList(genres: genres,);
  }
}
