import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moviesapp/bloc/get_person_bloc.dart';
import 'package:moviesapp/model/person.dart';
import 'package:moviesapp/model/person_response.dart';
import 'package:moviesapp/style/theme.dart' as Style;

class Persons extends StatefulWidget {
  const Persons({Key? key}) : super(key: key);

  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Persons> {
  @override
  void initState() {
    super.initState();
    personsBloc..getPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(
            "TRENDING PERSON ON THIS WEEK ",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Style.Colors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(height: 5),
        StreamBuilder<PersonResponse>(
            stream: personsBloc.subject.stream,
            builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.error != null &&
                    snapshot.data!.error.length > 0) {
                  return _buildErrorWidgets(snapshot.data?.error);
                }
                return buildPersonWidget(snapshot.data!);
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

  Widget buildPersonWidget(PersonResponse data) {
    List<Person> persons = data.persons;
    return Container(
      height: 136,
      padding: EdgeInsets.only(left: 10),
      child: ListView.builder(
          itemCount: persons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: 100,
              padding: EdgeInsets.only(top: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  persons[index].profileImg == null
                      ? Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Style.Colors.secondaryColor,
                          ),
                          child: Icon(
                            FontAwesomeIcons.userAlt,
                            color: Colors.white,
                          ),
                        )
                      : Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w200" +
                                          persons[index].profileImg),
                                  fit: BoxFit.cover))),
                  SizedBox(height: 10),
                  Text(persons[index].name, maxLines: 2, style:TextStyle(
                    fontSize: 10,
                    
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  color: Colors.white,
                  )),
                  Text('Trending for ${persons[index].name}',style:TextStyle(
                    color: Style.Colors.titleColor,
                    fontSize: 7,
                    fontWeight: FontWeight.w400
                  ))
                ],
              ),
            );
          }),
    );
  }
}
