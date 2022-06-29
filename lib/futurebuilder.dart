import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokeDexPage2 extends StatelessWidget {
  const PokeDexPage2({Key? key}) : super(key: key);

  Future<List<dynamic>> getImages() async {
    final url = Uri.parse('https://dummyjson.com/users');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as dynamic;
      return jsonResponse['users'];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Future Builder')),
      body: Center(
        child: FutureBuilder(
          future: getImages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var lista = snapshot.data as List<dynamic>;
              return GridView.count(
                  crossAxisCount: 3,
                  children:
                      lista.map((e) => Image.network(e['image'])).toList());
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
