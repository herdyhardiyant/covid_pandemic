import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data_structure/coronavirus_statistic.dart';

class CoronavirusDataProvider {
  Future<CoronavirusStatistic> retrieveCoronavirusDataByCountry(
      String countryName) async {
    final uri = Uri.parse(
        "https://corona.lmao.ninja/v2/countries/$countryName?yesterday=true&strict=true&query");

    try {
      final response = await http.get(uri);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      return CoronavirusStatistic(
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

  Future<CoronavirusStatistic> get globalStats async {
    final uri = Uri.parse("https://corona.lmao.ninja/v2/all?yesterday");

    try {
      final response = await http.get(uri);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return CoronavirusStatistic(id: "gloabl",
          countryName: "Global",
          totalConfirmedCases: extractedData["cases"],
          newConfirmedCases: extractedData["todayCases"],
          totalDeaths: extractedData["deaths"],
          newDeaths: extractedData["todayDeaths"]
      );
    } catch (error) {
      print("coronavirus_data_provider.dart | globalStats $error");
      rethrow;
    }
  }
}
