import 'package:covid_pandemic/providers/coronavirus_data_provider.dart';
import 'package:covid_pandemic/providers/countries_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/country_searchable_dropdown_menu.dart';
import '../widgets/coronavirus_data_tracker.dart';
import '../data_structure/coronavirus_statistic.dart';
import '../widgets/single_coronavirus_location_maps.dart';

class CoronavirusStatisticScreen extends StatefulWidget {
  const CoronavirusStatisticScreen({Key? key}) : super(key: key);
  static const routeName = "/coronavirus-statistic";

  @override
  _CoronavirusStatisticScreenState createState() =>
      _CoronavirusStatisticScreenState();
}

class _CoronavirusStatisticScreenState
    extends State<CoronavirusStatisticScreen> {
  String _selectedCountry = "";
  late GoogleMapController _mapController;
  late String _totalConfirmedCasesBySelectedMenu;
  late String _newConfirmedCasesBySelectedMenu;
  late String _totalDeathsBySelectedMenu;
  late String _newDeathsBySelectedMenu;
  late String _latestCovidDataDate;
  var _isLoading = true;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var statisticContainerHeight =
        media.size.height - media.padding.top - _appBar.preferredSize.height;
    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          height: statisticContainerHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CountrySearchableDropdownMenu(
                onChangeSelect: _changeSelectMenuHandler,
              ),
              const Divider(
                height: 24,
                thickness: 4,
              ),
              _buildCoronavirusStatisticContent,
              const Divider(
                height: 24,
                thickness: 4,
              ),
              SizedBox(
                  height: 200,
                  child: SingleCoronavirusLocationMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeSelectMenuHandler(String? selectedValue) async {

    setState((){
      _isLoading = true;
      _selectedCountry = selectedValue!;
      _initCovidDataBySelectedMenu();

      if(_selectedCountry.isEmpty || _selectedCountry == "Global"){
        return;
      }
    });
    final countryLocation = await Provider.of<CountriesDataProvider>(context, listen: false)
        .getCountryLocation(_selectedCountry);
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(countryLocation, 4.0));
    _mapController.showMarkerInfoWindow(MarkerId(_selectedCountry));
  }

  AppBar get _appBar {
    return AppBar(
      title: const Text("Coronavirus Statistic"),
    );
  }

  Widget get _loading {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 48, 0, 48),
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  Widget get _buildCoronavirusStatisticContent {
    if (_selectedCountry.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return Container(
          margin: const EdgeInsets.fromLTRB(0, 48, 0, 48),
          child: const Center(child: Text("Select country from the menu!")));
    }
    return _isLoading ? _loading : _coronavirusStatistic;
  }

  Future<void> _initCovidDataBySelectedMenu() async {
    final CoronavirusStatistic covidData;
    if (_selectedCountry == "Global") {
      covidData =
          await Provider.of<CoronavirusDataProvider>(context, listen: false)
              .globalStats;
      _initCovidStatisticData(covidData);
      return;
    }
    covidData =
        await Provider.of<CoronavirusDataProvider>(context, listen: false)
            .retrieveCoronavirusDataByCountry(_selectedCountry);

    _initCovidStatisticData(covidData);
  }

  void _initCovidStatisticData(CoronavirusStatistic covidData) {
    final numberFormatter = NumberFormat();
    _totalConfirmedCasesBySelectedMenu =
        numberFormatter.format(covidData.totalConfirmedCases);
    _newConfirmedCasesBySelectedMenu =
        numberFormatter.format(covidData.newConfirmedCases);
    _totalDeathsBySelectedMenu = numberFormatter.format(covidData.totalDeaths);
    _newDeathsBySelectedMenu = numberFormatter.format(covidData.newDeaths);
    final DateFormat dateFormatter = DateFormat.yMMMMd('en_US');
    final covidDate = DateTime.parse(DateTime.now().toString());
    _latestCovidDataDate = dateFormatter.format(covidDate);
    setState(() {
      _isLoading = false;
    });
  }

  Widget get _coronavirusStatistic {
    _initCovidDataBySelectedMenu();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(_latestCovidDataDate),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DataTracker(
              title: "Confirmed Cases",
              totalValue: _totalConfirmedCasesBySelectedMenu,
              additionalValue: "+$_newConfirmedCasesBySelectedMenu new cases"),
          const SizedBox(
            width: 12,
          ),
          DataTracker(
              title: "Deaths",
              totalValue: _totalDeathsBySelectedMenu,
              additionalValue: "+$_newDeathsBySelectedMenu new deaths"),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
    ]);
  }
}
