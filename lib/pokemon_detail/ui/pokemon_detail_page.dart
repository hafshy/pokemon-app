import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pokemon_detail/bloc/pokemon_detail_bloc.dart';
import 'package:pokemon_app/pokemon_detail/ui/pokemon_detail_content_landscape.dart';
import 'package:pokemon_app/pokemon_detail/ui/pokemon_detail_content_portrait.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonUrl;
  const PokemonDetailPage({super.key, required this.pokemonUrl});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  PokemonDetailBloc pokemonDetailBloc = PokemonDetailBloc();
  RegExp regex = RegExp(r'/(\d+)/$');

  String extractId(String url) {
    Match? match = regex.firstMatch(url);

    if (match != null) {
      String pokemonId = match.group(1)!;
      return pokemonId;
    } else {
      return "No ID found in the URL";
    }
  }

  String formatString(String input) {
    List<String> words = input.split("-");
    words = words.map((word) => _capitalizeFirstLetter(word)).toList();
    return words.join(" ");
  }

  String _capitalizeFirstLetter(String word) {
    if (word.isEmpty) {
      return word;
    }
    return word[0].toUpperCase() + word.substring(1);
  }

  @override
  void initState() {
    super.initState();
    pokemonDetailBloc.add(PokemonDetailInitialEvent(widget.pokemonUrl));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer(
        bloc: pokemonDetailBloc,
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.redAccent,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.favorite_border),
                    ),
                    color: Colors.white,
                  )
                ],
              ),
              backgroundColor: Colors.redAccent,
              body: state is LoadedPokemonDetail
                  ? width < height
                      ? PokemonDetailContentPortraitWidget(
                          pokemonDetail: pokemonDetailBloc.pokemonDetail!,
                          height: height,
                          width: width)
                      : PokemonDetailContentLandscapeWidget(
                          pokemonDetail: pokemonDetailBloc.pokemonDetail!,
                          height: height,
                          width: width)
                  : const Center(child: Text("Loading...")));
        },
        listener: (context, state) {},
        listenWhen: (previous, current) => current is PokemonDetailActionState,
        buildWhen: (previous, current) => current is! PokemonDetailActionState,
      ),
    );
  }
}
