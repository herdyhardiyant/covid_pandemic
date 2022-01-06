

class CountryCoronaStats {
  final String id;
  final String countryName;
  final int totalConfirmedCases;
  final int newConfirmedCases;
  final int totalDeaths;
  final int newDeaths;

  CountryCoronaStats(
      {required this.id,
      required this.countryName,
      required this.totalConfirmedCases,
      required this.newConfirmedCases,
      required this.totalDeaths,
      required this.newDeaths
      });
}
