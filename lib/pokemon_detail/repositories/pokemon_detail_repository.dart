import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokemon_app/pokemon_detail/models/pokemon_detail_model.dart';

class PokemonDetailRepository {
  static var client = http.Client();

  Future<PokemonDetailModel?> getPokemonDetail(nextUrl) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var url = Uri.parse(nextUrl);

    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return PokemonDetailModel.fromJson(data);
    } else {
      return null;
    }
  }
}
