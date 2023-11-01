import 'package:flutter/material.dart';
import 'package:pokemon_app/pokemon_detail/models/pokemon_detail_model.dart';
import 'package:pokemon_app/pokemon_list/ui/pokemin_list_page.dart';

class PokemonDetailTabBarWidget extends StatefulWidget {
  PokemonDetailModel pokemonDetail;
  PokemonDetailTabBarWidget({super.key, required this.pokemonDetail});

  @override
  State<PokemonDetailTabBarWidget> createState() =>
      _PokemonDetailTabBarWidgetState();
}

class _PokemonDetailTabBarWidgetState extends State<PokemonDetailTabBarWidget>
    with TickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Column(
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
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Height",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Weight",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Types",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text("Abilities",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.pokemonDetail.height} cm",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${widget.pokemonDetail.weight} kg",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.pokemonDetail.types
                                        .map((e) => formatString(e.type.name)
                                            .capitalize())
                                        .join(", "),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    widget.pokemonDetail.abilities
                                        .map((e) => formatString(e.ability.name)
                                            .capitalize())
                                        .join(", "),
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
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
                  itemCount: widget.pokemonDetail.stats.length + 1,
                  itemBuilder: (context, index) {
                    return index < widget.pokemonDetail.stats.length
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 124,
                                  child: Text(
                                    formatString(widget.pokemonDetail
                                            .stats[index].stat.name)
                                        .capitalize(),
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    widget.pokemonDetail.stats[index].baseStat
                                        .toString(),
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: LinearProgressIndicator(
                                      value: widget.pokemonDetail.stats[index]
                                              .baseStat /
                                          100,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<
                                          Color>(widget.pokemonDetail
                                                  .stats[index].baseStat <
                                              40
                                          ? Colors.yellowAccent
                                          : widget.pokemonDetail.stats[index]
                                                      .baseStat <
                                                  70
                                              ? Colors.orangeAccent
                                              : Colors
                                                  .redAccent), // Color of the progress indicator
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 124,
                                  child: Text(
                                    "Total",
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    widget.pokemonDetail.stats
                                        .map((e) => e.baseStat)
                                        .reduce(
                                            (value, element) => value + element)
                                        .toString(),
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: LinearProgressIndicator(
                                      value: widget.pokemonDetail.stats
                                              .map((e) => e.baseStat)
                                              .reduce((value, element) =>
                                                  value + element) /
                                          (widget.pokemonDetail.stats.length *
                                              100),
                                      backgroundColor: Colors.grey[200],
                                      valueColor: const AlwaysStoppedAnimation<
                                              Color>(
                                          Colors
                                              .green), // Color of the progress indicator
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                  }),
              const Text("Moves")
            ],
          ),
        ),
      ],
    );
  }
}
