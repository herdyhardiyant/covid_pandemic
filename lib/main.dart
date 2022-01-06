
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './pages/coronavirus_statistic_screen.dart';
import './providers/coronavirus_data_provider.dart';
import './providers/countries_data_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const CoronavirusTracker());
}

class CoronavirusTracker extends StatelessWidget {
  const CoronavirusTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => CoronavirusDataProvider()),
        Provider(create: (_) => CountriesDataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coronavirus Tracker',
        theme: ThemeData.dark(),
        home: const CoronavirusStatisticScreen()
      ),
    );
  }
}
