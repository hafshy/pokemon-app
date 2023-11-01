import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pokemon_list/bloc/pokemon_list_bloc.dart';
import 'package:pokemon_app/pokemon_list/ui/pokemin_list_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => PokemonListBloc(),
        child: const PokemonListPage(),
      ),
      theme: ThemeData(useMaterial3: true),
    );
  }
}
