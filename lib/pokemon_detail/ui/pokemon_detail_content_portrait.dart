import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/pokemon_detail/models/pokemon_detail_model.dart';
import 'package:pokemon_app/pokemon_detail/ui/pokemon_detail_tab_bar.dart';
import 'package:pokemon_app/pokemon_list/ui/pokemin_list_page.dart';

class PokemonDetailContentPortraitWidget extends StatefulWidget {
  PokemonDetailModel pokemonDetail;
  double height;
  double width;
  PokemonDetailContentPortraitWidget(
      {super.key,
      required this.pokemonDetail,
      required this.height,
      required this.width});

  @override
  State<PokemonDetailContentPortraitWidget> createState() =>
      _PokemonDetailContentPortraitWidgetState();
}

class _PokemonDetailContentPortraitWidgetState
    extends State<PokemonDetailContentPortraitWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.pokemonDetail.name.capitalize(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "#${widget.pokemonDetail.id}",
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
                  itemCount: widget.pokemonDetail.types.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white30,
                        ),
                        child: Text(
                          widget.pokemonDetail.types[index].type.name
                              .capitalize(),
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
                height: widget.width * 0.5,
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
                  height: widget.height * 0.75 - 200,
                  width: widget.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: PokemonDetailTabBarWidget(
                        pokemonDetail: widget.pokemonDetail),
                  ),
                )),
            Positioned(
                left: widget.width * 0.5 - widget.width * 0.25,
                child: CachedNetworkImage(
                    height: widget.width * 0.5,
                    imageUrl: widget.pokemonDetail.sprites.other!
                        .officialArtwork.frontDefault)),
          ]),
        )
      ],
    );
  }
}
