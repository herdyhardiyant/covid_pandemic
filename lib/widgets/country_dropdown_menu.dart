import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/countries_data_provider.dart';

class CountryDropdownMenu extends StatefulWidget {
  final void Function(String selectedItem) onChanged;
  final String selectedMenu;

  const CountryDropdownMenu({Key? key, required this.onChanged, required this.selectedMenu})
      : super(key: key);

  @override
  _CountryDropdownMenuState createState() => _CountryDropdownMenuState();
}

class _CountryDropdownMenuState extends State<CountryDropdownMenu> {
  late List<String> _allCountriesName;
  late String _dropdownValue;
  late List<DropdownMenuItem<String>> _menuItems;
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    _dropdownValue = widget.selectedMenu;
    _retrieveAllCountriesName().then((_) {
       _buildAllDropdownItems();
    }).then((_) {
      _turnOffLoading();
    });
    super.didChangeDependencies();
  }

 @override
  void didUpdateWidget(covariant CountryDropdownMenu oldWidget) {
    _dropdownValue = widget.selectedMenu;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white60),
          borderRadius: BorderRadius.circular(4)),
      child: _isLoading
          ? _buildLoading()
          : DropdownButtonHideUnderline(
              child: _buildDropdownButton(),
            ),
    );
  }

  Future<void> _retrieveAllCountriesName() async {
    final countriesName =
        await Provider.of<CountriesDataProvider>(context, listen: false)
            .retrieveAllTheAvailableCountriesName;

    /// Global, to show global corona stats
    _allCountriesName = ["Global" ,_dropdownValue, ...countriesName];
    _removeAllDuplicatesInDropdownMenu();
  }

  void _removeAllDuplicatesInDropdownMenu(){
    _allCountriesName = _allCountriesName.toSet().toList();
  }

  void _turnOffLoading(){
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildDropdownButton(){
    return DropdownButton<String>(
      value: _dropdownValue,
      menuMaxHeight: 200.0,
      items: _menuItems,
      onChanged: _changeDropdownButtonHandler,

    );
  }

  void _buildAllDropdownItems(){
    _menuItems = _allCountriesName
        .map<DropdownMenuItem<String>>(_buildDropdownMenuItem)
        .toList();
  }

  void _changeDropdownButtonHandler(String? selectedCountryName){
    _updateCurrentlySelectedMenu(selectedCountryName);
    widget.onChanged(selectedCountryName!);
  }

  void _updateCurrentlySelectedMenu(String? selectedCountryName){
    setState(() {
      _dropdownValue = selectedCountryName!;
    });
  }

  DropdownMenuItem<String> _buildDropdownMenuItem(String countryName){
    return DropdownMenuItem(
      child: Text(countryName),
      value: countryName,
    );
  }

  Widget _buildLoading(){
    return const Center(
      heightFactor: 1.5,
      child: CircularProgressIndicator(),
    );
  }

}
