import 'package:covid_pandemic/providers/countries_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CoronavirusMap extends StatefulWidget {
  final void Function(GoogleMapController mapController) onMapCreated;
  final void Function(String selectedCountryMarker) onTapMarker;

  const CoronavirusMap({
    Key? key,
    required this.onMapCreated, required this.onTapMarker,
  }) : super(key: key);

  @override
  State<CoronavirusMap> createState() => _CoronavirusMapState();
}

class _CoronavirusMapState extends State<CoronavirusMap> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.satellite,
      onMapCreated: (mapController) {
        widget.onMapCreated(mapController);
        _buildAllCountriesMarker();
      },
      indoorViewEnabled: false,
      markers: _markers,
      initialCameraPosition: const CameraPosition(target: LatLng(0, 0)),
    );
  }

  Future<void> _buildAllCountriesMarker() async {
    final allCountriesCasesAndLocation =
        await Provider.of<CountriesDataProvider>(context, listen: false)
            .retrieveAllCountriesLocation;
    setState(() {
      _buildMarkers(allCountriesCasesAndLocation);
    });
  }

  void _buildMarkers(List<Map<String, dynamic>> countriesData) async {
    for (var country in countriesData) {
      final String name = country["countryName"];
      final LatLng location = country["location"];

      _markers.add(Marker(
        markerId: MarkerId(name),
        position: location,
        infoWindow: InfoWindow(title: name),
        onTap: (){
          widget.onTapMarker(name);
        }
      ));
    }
  }
}
