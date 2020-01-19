import 'package:flutter/material.dart';
import 'package:movies/src/model/actors.dart';
import 'package:movies/src/model/movie.dart';
import 'package:movies/src/providers/movies_provider.dart';
import 'package:movies/src/utils/screen_utils.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Movie _movie;

  @override
  Widget build(BuildContext context) {
    _movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0),
              _createTitlePoster(context),
              _createDescription(),
              _createDescription(),
              _createDescription(),
              _createDescription(),
              _createCast(),
            ]),
          )
        ],
      ),
    );
  }

  Widget _createAppBar(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80),
        title: Text('${_movie.title}'),
        background: FadeInImage(
          image: NetworkImage(_movie.getBackgroundImage()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _createTitlePoster(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Hero(
              tag: _movie.uniqueId,
              transitionOnUserGestures: true,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: NetworkImage(_movie.getPosterURL()),
                  height: 150.0,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _movie.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(_movie.originalTitle,
                      style: Theme.of(context).textTheme.subhead),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star_border),
                      Text(_movie.voteAverage.toString(),
                          style: Theme.of(context).textTheme.subhead),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget _createDescription() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Text(
        _movie.overview,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget _createCast() {
    final movieProvider = MoviesProvider();

    return FutureBuilder(
      future: movieProvider.getCast(_movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData)
          return _createCastPageView(snapshot.data);
        else
          return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _createCastPageView(List<Actor> actorList) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actorList.length,
        itemBuilder: (context, position) =>_createActorCard(actorList[position]),

      ),
    );
  }

  Widget _createActorCard(Actor actor) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(actor.getPhoto()),
            placeholder: AssetImage('assets/img/loading.gif'),
            height: 150.0,
            fit: BoxFit.fill,
          ),
        ),
        Text(actor.name),
      ],
    );
  }
}
