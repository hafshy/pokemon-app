import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pokemon_detail/bloc/pokemon_detail_bloc.dart';
import 'package:pokemon_app/pokemon_list/ui/pokemin_list_page.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonUrl;
  const PokemonDetailPage({super.key, required this.pokemonUrl});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage>
    with TickerProviderStateMixin {
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
    TabController _tabController = TabController(length: 3, vsync: this);
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
                            Positioned(
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
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            child: TabBar(
                                              controller: _tabController,
                                              tabs: const [
                                                Tab(
                                                  text: "About",
                                                ),
                                                Tab(
                                                  text: "Stats",
                                                ),
                                                Tab(
                                                  text: "Moves",
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            // height: 200,
                                            child: TabBarView(
                                              controller: _tabController,
                                              children: [
                                                SingleChildScrollView(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 100,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Height",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Text(
                                                                    "Weight",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Text(
                                                                    "Types",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  Text(
                                                                      "Abilities",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          color: Colors
                                                                              .grey,
                                                                          fontWeight:
                                                                              FontWeight.w500))
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "${pokemonDetailBloc.pokemonDetail!.height} cm",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      "${pokemonDetailBloc.pokemonDetail!.weight} kg",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Text(
                                                                      pokemonDetailBloc
                                                                          .pokemonDetail!
                                                                          .types
                                                                          .map((e) => formatString(e.type.name)
                                                                              .capitalize())
                                                                          .join(
                                                                              ", "),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                    Text(
                                                                      pokemonDetailBloc.pokemonDetail !=
                                                                              null
                                                                          ? pokemonDetailBloc
                                                                              .pokemonDetail!
                                                                              .abilities
                                                                              .map((e) => formatString(e.ability.name).capitalize())
                                                                              .join(", ")
                                                                          : "",
                                                                      style: const TextStyle(
                                                                          overflow: TextOverflow
                                                                              .ellipsis,
                                                                          fontSize:
                                                                              20,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    )
                                                                  ]),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                ListView.builder(
                                                    itemCount: pokemonDetailBloc
                                                        .pokemonDetail!
                                                        .stats
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 12.0),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 124,
                                                              child: Text(
                                                                formatString(pokemonDetailBloc
                                                                        .pokemonDetail!
                                                                        .stats[
                                                                            index]
                                                                        .stat
                                                                        .name)
                                                                    .capitalize(),
                                                                style: const TextStyle(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 12,
                                                            ),
                                                            SizedBox(
                                                              width: 40,
                                                              child: Text(
                                                                pokemonDetailBloc
                                                                    .pokemonDetail!
                                                                    .stats[
                                                                        index]
                                                                    .baseStat
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Center(
                                                                child:
                                                                    LinearProgressIndicator(
                                                                  value: pokemonDetailBloc
                                                                          .pokemonDetail!
                                                                          .stats[
                                                                              index]
                                                                          .baseStat /
                                                                      100,
                                                                  backgroundColor:
                                                                      Colors.grey[
                                                                          200],
                                                                  valueColor: const AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .redAccent), // Color of the progress indicator
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                Text("Moves")
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                )),
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
                  : Text("loading"));
        },
        listener: (context, state) {},
        listenWhen: (previous, current) => current is PokemonDetailActionState,
        buildWhen: (previous, current) => current is! PokemonDetailActionState,
      ),
    );
  }
}
