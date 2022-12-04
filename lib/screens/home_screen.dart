import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_provider.dart';
import 'package:movies_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  // aqui s'ensenya un swipper y scroll dels poster de ses pelis y un boto search
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: true);

    print(moviesProvider.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartellera'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(moviesProvider.onDisplayMovies),
                );
              },
              icon: const Icon(Icons.search_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Targetes principals
              CardSwiper(movies: moviesProvider.onDisplayMovies),

              // Slider de pel·licules
              MovieSlider(movies: moviesProvider.onOnPopular),
              // Poodeu fer la prova d'afegir-ne uns quants, veureu com cada llista és independent
              // MovieSlider(),
              // MovieSlider(),
            ],
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  // Metodo Search Con la ayuda de Andrés, obre una finestra quan es pitja es search on surten tots els valors de la llista, direccionant a el details screen de la peli
  final List<Movie> resultado;

  MySearchDelegate(this.resultado);
  @override
  List<Widget>? buildActions(BuildContext context) {
    [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Text(query, style: const TextStyle(fontSize: 20)),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> buscar = [];

    for (int i = 0; i < resultado.length; i++) {
      buscar.add(resultado[i].title);
    }
    print(buscar.length);

    List<String> suggestions = buscar.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];

          return ListTile(
            title: Text(suggestion),
            onTap: () {
              query = suggestion;
              for (int i = 0; i < resultado.length; i++) {
                if (resultado[i].title == query) {
                  Movie enviar = resultado[i];
                  Navigator.pushNamed(context, 'details', arguments: enviar);
                }
              }
              query = '';
            },
          );
        });
  }
}
