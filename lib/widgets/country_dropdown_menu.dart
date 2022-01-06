import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/countries_data_provider.dart';

class CountryDropdownMenu extends StatefulWidget {
  final void Function(String selectedItem) onChanged;

  const CountryDropdownMenu({Key? key, required this.onChanged})
      : super(key: key);

  @override
  _CountryDropdownMenuState createState() => _CountryDropdownMenuState();
}

class _CountryDropdownMenuState extends State<CountryDropdownMenu> {
  List<String> _allCountriesName = ["Global"];
  String _dropdownValue = "Global";
  var _isLoading = true;

  @override
  void initState() {
    _retrieveAllCountriesName();
    super.initState();
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
          ? const Center(
              heightFactor: 1.5,
              child: CircularProgressIndicator(),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _dropdownValue,
                hint: const Text("Select Menu"),
                menuMaxHeight: 200.0,
                items: _allCountriesName
                    .map<DropdownMenuItem<String>>(
                        (countryName) => DropdownMenuItem(
                              child: Text(countryName),
                              value: countryName,
                            ))
                    .toList(),
                onChanged: (String? selectedCountryName) {
                  setState(() {
                    _dropdownValue = selectedCountryName!;
                  });
                  widget.onChanged(selectedCountryName!);
                },
              ),
            ),
    );
  }

  Future<void> _retrieveAllCountriesName() async {
    final countriesName =
        await Provider.of<CountriesDataProvider>(context, listen: false)
            .retrieveAllTheAvailableCountriesName;

    /// Add global menu, to show global stats
    _allCountriesName = [..._allCountriesName, ...countriesName];
    setState(() {
      _isLoading = false;
    });
  }
}
