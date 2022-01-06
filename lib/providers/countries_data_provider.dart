import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountriesDataProvider {
  Future<List<String>> get retrieveAllTheAvailableCountriesName async {
    final uri =
        Uri.parse("https://corona.lmao.ninja/v2/countries?yesterday&sort");

    try {
      final response = await http.get(uri);
      final extractedData = json.decode(response.body) as List<dynamic>;
      List<String> countriesName = [];
      for (var country in extractedData) {
        countriesName.add(country["country"]);
      }
      return countriesName;
    } catch (error) {
      print(
          " coronavirus_data_provider_old.dart _retrieveSummaryData() $error");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> get retrieveAllCountriesLocation async {
    final uri =
    Uri.parse("https://corona.lmao.ninja/v2/countries?yesterday&sort"
    );
    try {
      final response = await http.get(uri);
      final extractedData = json.decode(response.body) as List<dynamic>;
      List<Map<String, dynamic>> allCountriesLocation = [];
      for(var country in extractedData){
        final double long = (country["countryInfo"]["long"]).toDouble();
        final double lat = (country["countryInfo"]["lat"]).toDouble();
        final countryData = {
          "countryName": country["country"],
          "location": LatLng(lat, long)
        };
        allCountriesLocation.add(countryData);
      }
      return allCountriesLocation;
    } catch (error) {
      print(
          " coronavirus_data_provider_old.dart _retrieveSummaryData() $error");
      rethrow;
    }
  }

  Future<LatLng> getCountryLocation(String countryName) async {
    final uri = Uri.parse(
        "https://corona.lmao.ninja/v2/countries/$countryName?yesterday=true&strict=true&query");
    try {
      final response = await http.get(uri);
      final extractedData = json.decode(response.body);
      final double latitude = (extractedData["countryInfo"]["lat"]).toDouble();
      final double longitude = (extractedData["countryInfo"]["long"]).toDouble();
      return LatLng( latitude.toDouble(),
          longitude.toDouble());
    } catch (error) {
      print("countries_data_provider.dart | getCountryLocation() | $error");
      return const LatLng(0, 0);
    }
  }
}
