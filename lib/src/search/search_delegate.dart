import 'package:flutter/material.dart';
import 'package:movies/src/model/movie.dart';
import 'package:movies/src/providers/movies_provider.dart';

class SearchData extends SearchDelegate {
  final movies = [
    'Spiderman',
    'Capitan America',
    'Los vengadores',
    'Ghost Rider',
    'Iron Man',
    'Iron Man 2',
    'Iron Man 3',
    'Iron Man 4',
  ];

  final recents = [
    'Spiderman',
    'Los Vengadores',
  ];

  // String _selection;

  final moviewProvider = MoviesProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    //Las acciones/iconos del appBar

    var btnClear = IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        query = '';
      },
    );

    return [btnClear];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquierda del appbar
    var btnBack = IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
    return btnBack;
  }

  @override
  Widget buildResults(BuildContext context) {
    //crea los resultados que vamos a mostrar. 
    //se invoca solo al llamar al metodo showResults()
    // return Center(
    //   child: Container(
    //     height: 100.0,
    //     child: Text('Hola Mundo'),
    //     color: Colors.amberAccent,
    //   ),
    // );
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Son las sugerencias que aparecen cuando la persona escribe
    if(query.isEmpty)
      return Container();

    return FutureBuilder(
      future: moviewProvider.searchMovie(query), 
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {

        if(snapshot.hasData){
          var movies = snapshot.data;

          if(movies.length == 0)
            return Center(child: Text('Sin resultados'));

          return _getListView(movies, context);
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _getListView(List<Movie> movies, BuildContext context){
    return ListView(
      children: movies.map((movie){

        return ListTile(
          leading: FadeInImage(
            image: NetworkImage(movie.getPosterURL()),
            placeholder: AssetImage('assets/img/no-image.jpg'),
            height: 50.0,
            fadeInDuration: Duration(milliseconds: 50),
            fit: BoxFit.contain,
          ),

          title: Text(movie.title),
          subtitle: Text(movie.originalTitle),
          onTap: () => _gotoDetails(movie, context),
        );
      }).toList(),

    );
  }

  void _gotoDetails(Movie movie, BuildContext context){
    // close(context, null);
    movie.uniqueId = '';
    Navigator.pushNamed(context, 'details', arguments: movie);
    // showResults(context);
  }

//Codigo de ejemplo 
  /* @override
  Widget buildSuggestions(BuildContext context) {
    //Son las sugerencias que aparecen cuando la persona escribe

    final subgestList = (query.isEmpty)
        ? recents
        : movies
            .where((item) => item.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: subgestList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(subgestList[index]),
          onTap: () {
            // _selection = subgestList[index];
            // showResults(context);
            gotoDetails();
          },
        );
      },
    );
  } */
}
