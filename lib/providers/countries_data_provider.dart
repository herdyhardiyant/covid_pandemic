import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountriesDataProvider {
  Future<List<String>> get retrieveAllTheAvailableCountriesName async {

    try {
      const url = "https://corona.lmao.ninja/v2/countries?yesterday&sort";
      final extractedData = await _retrieveData(url) as List<dynamic>;
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

    try {
      const url = "https://corona.lmao.ninja/v2/countries?yesterday&sort";
      final extractedData = await _retrieveData(url) as List<dynamic>;

      List<Map<String, dynamic>> allCountriesLocation = [];
      for(var country in extractedData){
        final countryData = _createCountryLocationMap(country);
        allCountriesLocation.add(countryData);
      }

      return allCountriesLocation;
    } catch (error) {
      print(
          " coronavirus_data_provider_old.dart _retrieveSummaryData() $error");
      rethrow;
    }
  }

  Map<String, dynamic> _createCountryLocationMap(Map countryData){
    final double long = (countryData["countryInfo"]["long"]).toDouble();
    final double lat = (countryData["countryInfo"]["lat"]).toDouble();
    final countryLocation = {
      "countryName": countryData["country"],
      "location": LatLng(lat, long)
    };
    return countryLocation;
  }


  Future<LatLng> getCountryLocation(String countryName) async {
    try {
      final url = "https://corona.lmao.ninja/v2/countries/$countryName?yesterday=true&strict=true&query";
      final extractedData = await _retrieveData(url) as Map;
      final double latitude = (extractedData["countryInfo"]["lat"]).toDouble();
      final double longitude = (extractedData["countryInfo"]["long"]).toDouble();
      return LatLng( latitude.toDouble(),
          longitude.toDouble());
    } catch (error) {
      print("countries_data_provider.dart | getCountryLocation() | $error");
      return const LatLng(0, 0);
    }
  }

  Future<dynamic> _retrieveData(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final extractedData = json.decode(response.body);
    return extractedData;
  }

}
