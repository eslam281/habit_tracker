import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<List<String>> fetchCountries() async {
  List<String> countryList =[];
  try {
    final apiKey = dotenv.get('KEY');
    final response =
    await http.get(Uri.parse('https://api.restcountries.com/countries/v5'),
        headers: {
          'Authorization': apiKey
        }
    );
    if (response.statusCode == 200) {
      Map jsonMap = json.decode(response.body);
      Map data = jsonMap['data'];
      List<dynamic> countriesJson = data['objects'];
      countryList = countriesJson
          .map((country) => country['names']['common'] as String).toList();
    } else {
      throw Exception('Failed to load countries');
    }
  }catch(e){
    throw Exception('Failed to load countries catch $e');
  }
  return countryList;
}

