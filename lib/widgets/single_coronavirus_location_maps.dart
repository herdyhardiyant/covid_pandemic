import 'package:covid_pandemic/providers/countries_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleCoronavirusLocationMap extends StatefulWidget {
  final void Function(GoogleMapController mapController) onMapCreated;

  const SingleCoronavirusLocationMap({
    Key? key,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  State<SingleCoronavirusLocationMap> createState() =>
      _SingleCoronavirusLocationMapState();
}

class _SingleCoronavirusLocationMapState
    extends State<SingleCoronavirusLocationMap> {
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

  /// Circle radius is based of the total cases
  Future<void> _buildAllCountriesMarker() async {
    final allCountriesCasesAndLocation =
        await Provider.of<CountriesDataProvider>(context, listen: false)
            .retrieveAllCountriesLocation;
    setState(() {
      _buildCircle(allCountriesCasesAndLocation);
    });
  }

  void _buildCircle(List<Map<String, dynamic>> countriesData) {
    for (var country in countriesData) {
      final String name = country["countryName"];
      final LatLng location = country["location"];
      _markers.add(
        Marker(
            markerId: MarkerId(name),
            position: location,
          infoWindow: InfoWindow(title: name)
        ),
      );
    }
  }
}
