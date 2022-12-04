import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

import '../models/popular_response.dart';

class MoviesProvider extends ChangeNotifier {
  // clase que es conecta amb l'api de ses pelis y retorna valors segons el que se demani
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = 'e191a985b711e935ead4d89d336ebfac';
  String _language = 'en-US';
  String _page = '1';

  List<Movie> onDisplayMovies = [];
  List<Movie> onOnPopular = [];

  Map<int, List<Cast>> casting = {};
  //https://api.themoviedb.org/3/movie/now_playing?api_key=e191a985b711e935ead4d89d336ebfac&language=en-US&page=1
  MoviesProvider() {
    print('Movies Provider Inicialitzat');
    this.getOnDisplayMovies();
    this.getOnPopular();
  }

  getOnDisplayMovies() async {
    // reb api de les pelis actuals
    print('getOnDisplayMovies');
    var url = Uri.https(_baseUrl, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language, 'page': _page});

    // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);
    print(result.statusCode);

    final nowPlayingResponse = NowPlayingResponse.fromJson(result.body);

    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getOnPopular() async {
    // reb api de pelis populars
    var url = Uri.https(_baseUrl, '3/movie/popular',
        {'api_key': _apiKey, 'lenguage': _language, 'page': _page});

    // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final popularResponse = PopularResponse.fromJson(result.body);

    onOnPopular = popularResponse.results;

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int idMovie) async {
    // reb api dels autors
    print('Demanam info al servidor!');
    var url = Uri.https(_baseUrl, '3/movie/$idMovie/credits',
        {'api_key': _apiKey, 'language': _language});

    // Await the http get response, then decode the json-formatted response.
    final result = await http.get(url);

    final creditsResponse = CreditsResponse.fromJson(result.body);

    casting[idMovie] = creditsResponse.cast;

    return creditsResponse.cast;
  }
}
