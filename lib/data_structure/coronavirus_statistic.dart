

class CoronavirusStatistic {
  final String id;
  final String countryName;
  final int totalConfirmedCases;
  final int newConfirmedCases;
  final int totalDeaths;
  final int newDeaths;

  CoronavirusStatistic(
      {required this.id,
      required this.countryName,
      required this.totalConfirmedCases,
      required this.newConfirmedCases,
      required this.totalDeaths,
      required this.newDeaths
      });
}
