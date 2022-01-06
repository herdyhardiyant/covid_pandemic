import 'package:covid_pandemic/providers/coronavirus_data_provider.dart';
import 'package:covid_pandemic/providers/countries_data_provider.dart';
import 'package:covid_pandemic/widgets/country_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/coronavirus_data_tracker.dart';
import '../data_structure/coronavirus_statistic.dart';
import '../widgets/coronavirus_map.dart';

class CoronavirusStatisticScreen extends StatefulWidget {
  const CoronavirusStatisticScreen({Key? key}) : super(key: key);

  @override
  _CoronavirusStatisticScreenState createState() =>
      _CoronavirusStatisticScreenState();
}

class _CoronavirusStatisticScreenState
    extends State<CoronavirusStatisticScreen> {
  String _selectedCountry = "Global";
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
  void initState() {
    _initCovidDataBySelectedMenu();
    super.initState();
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
              CountryDropdownMenu(onChanged: _changeSelectedCountryHandler),
              _buildDivider(),
              _isLoading ? _loading : _buildCoronavirusStatistic(),
              _buildDivider(),
              _buildCoronavirusMap()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(){
    return const Divider(
      height: 24,
      thickness: 4,
    );
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
  Widget _buildCoronavirusMap(){
    return SizedBox(
        height: 200,
        child: CoronavirusMap(
          onMapCreated: (controller) {
            _mapController = controller;
          },
        ));
  }

  Future<void> _changeSelectedCountryHandler(String? selectedValue) async {
    setState(() {
      _isLoading = true;
      _selectedCountry = selectedValue!;
      _initCovidDataBySelectedMenu();
    });

    if (_selectedCountry.isEmpty || _selectedCountry == "Global") {
      _animateCameraForGlobalData();
      return;
    }
    _animateCameraToTheSelectedCountry();
  }

  void _animateCameraForGlobalData() {
    _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(const LatLng(0, 0), 0.0));
  }

  Future<void> _animateCameraToTheSelectedCountry() async {
    final countryLocation = await Provider.of<CountriesDataProvider>(
        context, listen: false)
        .getCountryLocation(_selectedCountry);
    _mapController.animateCamera(
        CameraUpdate.newLatLngZoom(countryLocation, 4.0));
    _mapController.showMarkerInfoWindow(MarkerId(_selectedCountry));
  }



  Future<void> _initCovidDataBySelectedMenu() async {
    if (_selectedCountry == "Global") {
      _initCovidDGlobalData();
      return;
    }
    _initCovidDataByCountry();
  }

  Future<void> _initCovidDGlobalData() async {
    final CoronavirusStatistic covidData =
    await Provider
        .of<CoronavirusDataProvider>(context, listen: false)
        .globalStats;
    _initCovidData(covidData);
  }

  Future<void> _initCovidDataByCountry() async {
    final CoronavirusStatistic covidData =
    await Provider.of<CoronavirusDataProvider>(context, listen: false)
        .retrieveCoronavirusDataByCountry(_selectedCountry);
    _initCovidData(covidData);
  }

  void _initCovidData(CoronavirusStatistic covidData) {
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
    _turnOffLoading();
  }

  void _turnOffLoading(){
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildCoronavirusStatistic() {
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
