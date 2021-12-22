import 'package:flutter/material.dart';
import '../model/cast_response.dart';
import '../style/theme.dart' as Style;
import '../bloc/get_cast_bloc.dart';
import '../model/cast.dart';

class Casts extends StatefulWidget {
  final int id;
  const Casts({Key? key, required this.id}) : super(key: key);

  @override
  _CastsState createState() => _CastsState(id);
}

class _CastsState extends State<Casts> {
  final int id;
  _CastsState(this.id);
  @override
  void initState() {
    super.initState();
    castBloc..getCast(id);
  }

  @override
  void dispose() {
    castBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 20),
          child: Text(
            "CASTS",
            style: TextStyle(
                color: Style.Colors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<CastResponse>(
            stream: castBloc.subject.stream,
            builder: (context, AsyncSnapshot<CastResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data?.error != null &&
                    snapshot.data!.error.length > 0) {
                  return _buildErrorWidgets(snapshot.data?.error);
                }
                return _castsWidget(snapshot.data!);
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
          Text('Error  ',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Colors.red.shade50)),
        ],
      ),
    );
  }

  Widget _castsWidget(CastResponse data) {
    List<Cast> casts = data.casts;

    return Container(
      height: 140,
      padding: EdgeInsets.only(left: 10),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: casts.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(top: 10, right: 8),
              width: 70,
              child: GestureDetector(
                onTap: () => {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 66,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w300/' +
                                    casts[index].image,
                              ))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      casts[index].name,
                      maxLines: 2,
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      casts[index].character,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Style.Colors.titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 7),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
