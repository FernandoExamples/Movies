import 'package:flutter/material.dart';
import 'package:movies/src/model/movie.dart';
import 'package:movies/src/providers/movies_provider.dart';
import 'package:movies/src/search/search_delegate.dart';
import 'package:movies/src/utils/screen_utils.dart' as utils;
import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/page_view_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final movieProvider = MoviesProvider();

  @override
  void initState() {
    super.initState();
    movieProvider.getPopulars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies'), centerTitle: false, actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: SearchData());
          },
        )
      ]),
      body: _createBody(),
    );
  }

  Widget _createBody() {
    return Column(
      children: <Widget>[
        _createSwiper(),
        _createFooter(context),
      ],
    );
  }

  Widget _createSwiper() {
    return FutureBuilder(
      future: movieProvider.getInCinemas(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            listMovies: snapshot.data,
            percentWidth: 0.7,
            percentHeight: 0.5,
            onTap: (movie){
              Navigator.pushNamed(context, 'details', arguments: movie);
            },
          );
        } else
          return Container(
            child: Center(child: CircularProgressIndicator()),
            height: utils.getPercentScreenHeigth(context, 0.5),
          );
      },
    );
  }

  Widget _createFooter(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child:
                Text('Populares', style: Theme.of(context).textTheme.subhead),
          ),
          SizedBox(height: 10.0),
          StreamBuilder(
            stream: movieProvider.popularsStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return HorizontalPageView(
                  listMovies: snapshot.data,
                  percentHeight: 0.2,
                  onNextPage: movieProvider.getPopulars,
                  onTap: (Movie movie) {
                    Navigator.pushNamed(context, 'details', arguments: movie);
                  },
                );
              } else
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                  height: utils.getPercentScreenHeigth(context, 0.27),
                );
            },
          ),
        ],
      ),
    );
  }
}
