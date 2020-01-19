class Movies {
  final List<Movie> movies = new List();

  Movies();

  /* aunque la lista que se recibe es equivalente a List<Map<String, dynamic>> 
  se debe poner dynamic porque el json de dart:converter regresa un dynamic
  */
  Movies.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null) return;

    for(var item in jsonList){
      final movie = Movie.fromJsonMap(item);
      movies.add(movie);
    }
  }
}

class Movie {

  String uniqueId; //propiedad creada por mi

  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  Movie({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  Movie.fromJsonMap(Map<String, dynamic> json) {
    popularity = json['popularity'] / 1; //se divide entre 1 para pasarlo a double cuando se reciba un x.0
    voteCount = json['vote_count'];
    video = json['video'];
    posterPath = json['poster_path'];
    id = json['id'];
    adult = json['adult'];
    backdropPath = json['backdrop_path'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    genreIds = json['genre_ids'].cast<int>();
    title = json['title'];
    voteAverage = json['vote_average'] / 1;
    overview = json['overview'];
    releaseDate = json['release_date'];
  }

  String getPosterURL(){
    if(posterPath == null)
      return 'https://www.bridgiot.co.za/wp-content/uploads/2018/12/1024x1024-no-image-available.png';
    else
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
  }

  String getBackgroundImage(){
    if(posterPath == null)
      return 'https://www.bridgiot.co.za/wp-content/uploads/2018/12/1024x1024-no-image-available.png';
    else
      return 'https://image.tmdb.org/t/p/w500/$backdropPath';
  }
}
