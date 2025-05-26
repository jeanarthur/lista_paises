import 'dart:convert' as convert;
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:lista_paises/models/pais.dart';

class PaisesManager {
  Future<List<Pais>> obterPaises() async {
    var url = Uri.https('restcountries.com', '/v3.1/all', {'fields': 'name,flags'});

    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> parsedListJson = convert.jsonDecode(response.body);
      log(parsedListJson.toString());
      List<Pais> itemsList = List<Pais>.from(parsedListJson.map<Pais>((dynamic i) => Pais.fromJson(i)));
      return itemsList;
    } else {
      log('Request failed with status: ${response.statusCode}.');
      return List.empty();
    }
  }
}