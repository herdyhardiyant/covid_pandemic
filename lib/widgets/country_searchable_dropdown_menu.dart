
import 'package:covid_pandemic/providers/countries_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';

class CountrySearchableDropdownMenu extends StatefulWidget {
  final void Function(String?) onChangeSelect;

  const CountrySearchableDropdownMenu({
    Key? key,
    required this.onChangeSelect,
  }) : super(key: key);

  @override
  State<CountrySearchableDropdownMenu> createState() =>
      _CountrySearchableDropdownMenuState();
}

class _CountrySearchableDropdownMenuState
    extends State<CountrySearchableDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      showSearchBox: true,
      onFind: (_) async {
          return Provider.of<CountriesDataProvider>(context, listen: false)
              .retrieveAllTheAvailableCountriesName;
      },

      showSelectedItems: true,
      mode: Mode.MENU,
      searchFieldProps: TextFieldProps(
          decoration: const InputDecoration(label: Text("Search Country"))),
      items: const ["Global"],
      selectedItem: "Select Country",
      onChanged: (itemValue) {
        widget.onChangeSelect(itemValue);
      },
    );
  }
}
