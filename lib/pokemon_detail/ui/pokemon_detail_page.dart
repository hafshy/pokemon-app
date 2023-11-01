import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pokemon_detail/bloc/pokemon_detail_bloc.dart';
import 'package:pokemon_app/pokemon_detail/ui/pokemon_detail_tab_bar.dart';
import 'package:pokemon_app/pokemon_list/ui/pokemin_list_page.dart';

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
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                pokemonDetailBloc.pokemonDetail?.name
                                        .capitalize() ??
                                    "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "#${pokemonDetailBloc.pokemonDetail?.id ?? ""}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8),
                          child: Container(
                              height: 40,
                              constraints: const BoxConstraints(
                                minHeight: 40,
                              ),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      pokemonDetailBloc.pokemonDetail != null
                                          ? pokemonDetailBloc
                                              .pokemonDetail!.types.length
                                          : 0,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Colors.white30,
                                        ),
                                        child: Text(
                                          pokemonDetailBloc.pokemonDetail !=
                                                  null
                                              ? pokemonDetailBloc.pokemonDetail!
                                                  .types[index].type.name
                                                  .capitalize()
                                              : "",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }))),
                        ),
                        Expanded(
                          child: Stack(children: [
                            Positioned(
                                height: 200,
                                top: 20,
                                right: -40,
                                child: Opacity(
                                  opacity: 0.2,
                                  child: Image.asset(
                                    "assets/pokeball.png",
                                  ),
                                )),
                            width < 500
                                ? Positioned(
                                    bottom: 0,
                                    child: Container(
                                      height: height * 0.75 - 200,
                                      width: width,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 40),
                                        child: PokemonDetailTabBarWidget(
                                            pokemonDetail: pokemonDetailBloc
                                                .pokemonDetail!),
                                      ),
                                    ))
                                : Container(),
                            Positioned(
                                left: width * 0.5 - 120,
                                child: CachedNetworkImage(
                                    height: 240,
                                    imageUrl: pokemonDetailBloc
                                        .pokemonDetail!
                                        .sprites
                                        .other!
                                        .officialArtwork
                                        .frontDefault)),
                          ]),
                        )
                      ],
                    )
                  : const Center(child: Text("Loading...")));
        },
        listener: (context, state) {},
        listenWhen: (previous, current) => current is PokemonDetailActionState,
        buildWhen: (previous, current) => current is! PokemonDetailActionState,
      ),
    );
  }
}
