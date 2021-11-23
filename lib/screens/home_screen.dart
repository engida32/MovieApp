import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import "package:flutter/material.dart";
import 'package:moviesapp/style/theme.dart' as Style;
import 'package:moviesapp/widget/genre.dart';
import 'package:moviesapp/widget/now_playing.dart';
import 'package:moviesapp/widget/person.dart';
import 'package:moviesapp/widget/topMovies.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        leading: Icon(EvaIcons.menu2Outline, color: Colors.white),
        title: Text("Movie App"),
        actions: [IconButton(onPressed: null, icon: Icon(EvaIcons.searchOutline, color: Colors.white))],
      ),
      body: ListView(
        children: [
          NowPlaying(),
          GenreScreen(),
          Persons(),
          TopMovies(),

        ],
      ),
    );
  }
}
