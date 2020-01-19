import 'dart:async';

import 'package:movies/src/model/actors.dart';
import 'package:movies/src/model/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MoviesProvider {
  String _apiKey = '2ea8ea675bd5a34a75e9428ca22adc65';
  String _url = 'api.themoviedb.org';
  String _languje = 'es-MX';

  int _page = 0;
  bool _loading = false;

  final _popularsList = List<Movie>();

  //crear los Streams
  final _streamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularsSink => _streamController.sink.add;

  Stream<List<Movie>> get popularsStream => _streamController.stream;

  void dispose() {
    _streamController.close();
  }

  Future<List<Movie>> getInCinemas() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _languje,
    });

    return await _processResponse(url);
  }

  Future<List<Movie>> getPopulars() async {
    if (_loading) return [];

    _loading = true;

    _page++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _languje,
      'page': _page.toString(),
    });

    final resp = await _processResponse(url);
    _popularsList.addAll(resp);

    popularsSink(_popularsList);

    _loading = false;
    return resp;
  }

  Future<List<Movie>> _processResponse(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final listMovies = Movies.fromJsonList(decodedData['results']);

    return listMovies.movies;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _languje,
    });
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = Cast.fromJsonMap(decodedData['cast']);

    return cast.actors;
  }

  Future<List<Movie>> searchMovie(String query) async {
    
    final url = Uri.https(_url, '3/search/movie', {
      'api_key': _apiKey,
      'language': _languje,
      'include_adult': true.toString(),
      'query': query,
    });

     return await _processResponse(url);  
  }
}
