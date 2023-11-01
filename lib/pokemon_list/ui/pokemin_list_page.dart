import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pokemon_detail/ui/pokemon_detail_page.dart';
import 'package:pokemon_app/pokemon_detail/ui/pokemon_detail_page_resp.dart';
import 'package:pokemon_app/pokemon_list/bloc/pokemon_list_bloc.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  PokemonListBloc pokemonListBloc = PokemonListBloc();
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

  @override
  void initState() {
    super.initState();
    pokemonListBloc.add(PokemonListInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocConsumer(
        bloc: pokemonListBloc,
        builder: (context, state) {
          // if (pokemonListBloc.isLoading) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          return CustomScrollView(
            slivers: [
              const SliverAppBar.large(
                title: Text("Pokedex"),
              ),
              (pokemonListBloc.isLoading)
                  ? const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: (index + 1) % (width / 250).ceil() == 1
                              ? const EdgeInsets.only(left: 10)
                              : (index + 1) % (width / 250).ceil() == 0
                                  ? const EdgeInsets.only(right: 10)
                                  : const EdgeInsets.only(),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PokemonDetailRespPage(
                                              pokemonUrl: pokemonListBloc
                                                  .pokemonList[index].url,
                                            )));
                              },
                              child: Stack(
                                children: [
                                  Positioned(
                                      bottom: -30,
                                      right: -30,
                                      child: Opacity(
                                        opacity: 0.2,
                                        child: Image.asset(
                                          "assets/pokeball.png",
                                          width: 160,
                                        ),
                                      )),
                                  Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Text(
                                        pokemonListBloc.pokemonList[index].name
                                            .capitalize(),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  Positioned(
                                      bottom: -32,
                                      right: -32,
                                      child: CachedNetworkImage(
                                          width: 160,
                                          imageUrl:
                                              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${extractId(pokemonListBloc.pokemonList[index].url)}.png"))
                                ],
                              ),
                            ),
                          ),
                        );
                      }, childCount: pokemonListBloc.pokemonList.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (width / 250).ceil(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: pokemonListBloc.isLoading
                        ? const CircularProgressIndicator()
                        : (state is LoadedPokemons)
                            ? TextButton(
                                onPressed: () {
                                  pokemonListBloc.add(PokemonListFetchEvent());
                                },
                                child: const Text("Load More"))
                            : Container(),
                  ),
                ),
              )
            ],
          );
        },
        listener: (context, state) {},
        listenWhen: (previous, current) => current is PokemonListActionState,
        buildWhen: (previous, current) => current is! PokemonListActionState,
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
