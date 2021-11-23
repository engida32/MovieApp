import 'package:flutter/material.dart';
import 'package:moviesapp/model/genre.dart';
import 'package:moviesapp/style/theme.dart' as Style;
import 'package:moviesapp/widget/genre_movies.dart';
//further study 
class GenreList extends StatefulWidget {
   final  List<Genre> genres;
  const GenreList({Key? key, required this.genres}) : super(key: key);

  @override
  _GenreListState createState() => _GenreListState(genres);
}

class _GenreListState extends State<GenreList>    with SingleTickerProviderStateMixin {
   List<Genre> genres = [];
  _GenreListState(this.genres);
  // _GenresListState(this.genres);
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: genres.length);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 307.0,
        child: DefaultTabController(
          length: genres.length,
          child: Scaffold(
            backgroundColor: Style.Colors.mainColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                backgroundColor: Style.Colors.mainColor,
                bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Style.Colors.mainColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3.0,
                  unselectedLabelColor: Style.Colors.titleColor,
                  labelColor: Colors.white,
                  isScrollable: true,
                  tabs: genres.map((Genre genre) {
                    return Container(
                        padding: EdgeInsets.only(bottom: 15.0, top: 10.0),
                        child: new Text(genre.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            )));
                  }).toList(),
                ),
              ),
            ),
            body: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children:genres.map((Genre genre){
                  return GenreMovies(genreId: genre.id,);
                }
           
              ).toList(),
          ),
        )));
  }
}
