import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data_structure/country_corona_stats.dart';

class CoronavirusDataProvider {
  Future<CountryCoronaStats> retrieveCoronavirusDataByCountry(
      String countryName) async {
    try {
      final url =
          "https://corona.lmao.ninja/v2/countries/$countryName?yesterday=true&strict=true&query";
      final extractedData = await _retrieveData(url) as Map<String, dynamic>;
      return CountryCoronaStats(
          id: extractedData["countryInfo"]["_id"].toString(),
          countryName: extractedData["country"],
          totalConfirmedCases: extractedData["cases"],
          newConfirmedCases: extractedData["todayCases"],
          totalDeaths: extractedData["deaths"],
          newDeaths: extractedData["todayDeaths"]);
    } catch (error) {
      print(
          "coronavirus_data_provider.dart | retrieveCoronavirusDataByCountry() $error");
      rethrow;
    }
  }

  Future<CountryCoronaStats> get globalStats async {
    try {
      const url = "https://corona.lmao.ninja/v2/all?yesterday";
      final extractedData = await _retrieveData(url) as Map<String, dynamic>;
      return CountryCoronaStats(
          id: "gloabl",
          countryName: "Global",
          totalConfirmedCases: extractedData["cases"],
          newConfirmedCases: extractedData["todayCases"],
          totalDeaths: extractedData["deaths"],
          newDeaths: extractedData["todayDeaths"]);
    } catch (error) {
      print("coronavirus_data_provider.dart | globalStats $error");
      rethrow;
    }
  }

  Future<dynamic> _retrieveData(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final extractedData = json.decode(response.body);
    return extractedData;
  }
}
