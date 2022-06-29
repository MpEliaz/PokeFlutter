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
  late TextEditingController _controller;

  void _fetchPokemon() async {
    var _random = Random();
    var _randomId = _random.nextInt(150);
    _isVisibleName = false;

    var url =
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${_controller.text}');
    if (_controller.text.isNotEmpty) {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;

        _pokemonName = jsonResponse['name'];
        _pokemonUrlImage = jsonResponse['sprites']['other']['official-artwork']
            ['front_default'];
        setState(() {});
      }
      if (response.statusCode == 404) {
        _pokemonName = ':(';
        _pokemonUrlImage =
            'https://cdn.dribbble.com/users/4040675/screenshots/10545158/media/85a3329e4202059593616d3b42f16e8d.png?compress=1&resize=400x300';

        setState(() {});
      }
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
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            Text(_pokemonName, style: const TextStyle(fontSize: 50)),
            TextField(
              controller: _controller,
            ),
            ElevatedButton(
                onPressed: () {
                  _fetchPokemon();
                },
                child: const Text('Obtener Pokemon!')),
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
