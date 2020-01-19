import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/model/movie.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> listMovies;

  final double percentHeight;
  final double percentWidth;
  final Function(Movie movie) onTap;

  CardSwiper(
      {@required this.listMovies,
      @required this.percentWidth,
      @required this.percentHeight,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemBuilder: _getBuilder(),
        itemCount: listMovies.length,
        itemWidth: _screenSize.width * percentWidth,
        itemHeight: _screenSize.height * percentHeight,
        layout: SwiperLayout.STACK,
        // control: new SwiperControl(),
        // pagination: new SwiperPagination(),
      ),
    );
  }

  /*
   * Funcion que se encarga de construir cada Widget del Swiper
   */
  Function _getBuilder() {
    return (BuildContext context, int index) {

      var card = ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: FadeInImage(
          image: NetworkImage(listMovies[index].getPosterURL()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 200),
          fit: BoxFit.fill,
        ),
      );

      listMovies[index].uniqueId = '${listMovies[index].id}-poster';

      var hero = Hero(
        child: card,
        tag: listMovies[index].uniqueId,
      );

      return GestureDetector(
        child: hero,
        onTap: () => onTap(listMovies[index]),
      );
    };
  }
}
