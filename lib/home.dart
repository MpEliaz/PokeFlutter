import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:pokedex/futurebuilder.dart';

class PokeDexPage extends StatefulWidget {
  const PokeDexPage({Key? key}) : super(key: key);

  @override
  State<PokeDexPage> createState() => _PokeDexPageState();
}

class _PokeDexPageState extends State<PokeDexPage> {
  var _pokemonName = '';
  var _pokemonUrlImage =
      'https://www.crearmemes.es/uploads/galeria/meme-136-pulp-fiction-john-travolta-confuso-gerador-de-memes.jpg';
  final _selectedPokemon = [];
  var _isVisibleName = false;

  void _fetchPokemon() async {
    var _random = Random();
    var _randomId = _random.nextInt(150);
    _isVisibleName = false;

    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$_randomId');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;

      _pokemonName = jsonResponse['name'];
      _pokemonUrlImage =
          jsonResponse['sprites']['other']['official-artwork']['front_default'];
      setState(() {});
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _addToSelectedPokemons() {
    setState(() {
      if (_selectedPokemon.length < 5) {
        _selectedPokemon.add(_pokemonUrlImage);
      }
    });
  }

  void _deletePokemon(url) {
    final index = _selectedPokemon.indexWhere((element) => element == url);

    _selectedPokemon.removeAt(index);

    setState(() {});
  }

  void _setNameVisible() {
    setState(() {
      _isVisibleName = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Como se llama el Pokemon?',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PokeDexPage2()),
                  );
                },
                child: const Icon(Icons.golf_course)),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              _pokemonUrlImage,
              height: 300,
            ),
            Visibility(
              visible: _isVisibleName,
              replacement:
                  const Text('**********', style: TextStyle(fontSize: 50)),
              child: Text(_pokemonName, style: const TextStyle(fontSize: 50)),
            ),
            ElevatedButton(
                onPressed: () {
                  _fetchPokemon();
                },
                child: const Text('Obtener Pokemon!')),
            ElevatedButton(
                onPressed: () {
                  _setNameVisible();
                },
                child: const Text('Descubrir Nombre!')),
            ElevatedButton(
                onPressed: _selectedPokemon.length >= 5
                    ? null
                    : _addToSelectedPokemons,
                child: const Text('Agregar al pokedex')),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _selectedPokemon
                    .map((e) => InkWell(
                          onDoubleTap: () {
                            _deletePokemon(e);
                          },
                          child: Image.network(
                            e,
                            height: 70,
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
