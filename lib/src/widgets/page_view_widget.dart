import 'package:flutter/material.dart';
import 'package:movies/src/model/movie.dart';

class HorizontalPageView extends StatelessWidget {
  final List<Movie> listMovies;
  final double percentHeight;
  final Function onNextPage;
  final Function(Movie movie) onTap;

  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  HorizontalPageView(
      {@required this.listMovies,
      @required this.percentHeight,
      @required this.onNextPage,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final _cardSize = _screenSize.height * percentHeight;
    final _containerSize = _cardSize + 60.0; //espacio para el titutlo

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) onNextPage();
    });

    return Container(
      height: _containerSize,
      child: PageView.builder(
        // children: _createCards(_cardSize, context),
        controller: _pageController,
        pageSnapping: false,
        itemCount: listMovies.length,
        itemBuilder: (context, position) =>
            _createCard(listMovies[position], _cardSize, context),
      ),
    );
  }

/*
 Metodo encargado de crear una sola tarjeta para usar en el
 PageView.builder que es mejor que el PageView solamente. 
 El PageView.builder renderiza los elementos bajo demanda  
 */
  Widget _createCard(Movie movie, double height, BuildContext context) {
    final card = Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: FadeInImage(
            image: NetworkImage(
              movie.getPosterURL(),
            ),
            placeholder: AssetImage('assets/img/loading.gif'),
            fadeInDuration: Duration(milliseconds: 200),
            fit: BoxFit.fill,
            height: height,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          movie.title,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );

    movie.uniqueId = '${movie.id}-pageView';

    var hero = Hero(
      transitionOnUserGestures: true,
      tag: movie.uniqueId,
      child: card,
    );

    return GestureDetector(
      child: hero,
      onTap: () => onTap(movie),
    );
  }

  /*
    Funcion encargada de regresar una lista de Widgets que seran
    paginados por el PageView
   */
  List<Widget> _createCards(double height, BuildContext context) {
    return listMovies.map((Movie movie) {
      return Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              image: NetworkImage(
                movie.getPosterURL(),
              ),
              placeholder: AssetImage('assets/img/loading.gif'),
              fadeInDuration: Duration(milliseconds: 200),
              fit: BoxFit.fill,
              height: height,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            movie.title,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      );
    }).toList();
  }
}
