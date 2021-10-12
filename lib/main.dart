import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scriptstudio/automatic_connection_screen.dart';
import 'languajes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // Inglés
        const Locale('es'), // Español
        const Locale('ca'), // Catalán
      ],
      debugShowCheckedModeBanner: false,
      title: 'ScriptStudio',
      theme: ThemeData(
        fontFamily: "Product Sans",
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.red,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.redAccent),
        scaffoldBackgroundColor: Colors.red,
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 96.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.5,
              color: Colors.white),
          headline2: TextStyle(
              fontSize: 60.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Colors.white),
          headline3: TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
              color: Colors.white),
          headline4: TextStyle(
              fontSize: 34.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.25,
              color: Colors.white),
          headline5: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
              color: Colors.white),
          headline6: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.15,
              color: Colors.white),
          bodyText1: TextStyle(fontSize: 16.0, letterSpacing: 0.5),
          bodyText2: TextStyle(fontSize: 14.0, letterSpacing: 0.25),
          button: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.25,
              color: Colors.white),
          caption: TextStyle(fontSize: 12.0, letterSpacing: 0.4),
          overline: TextStyle(fontSize: 10.0, letterSpacing: 1.5),
          subtitle1: TextStyle(
              fontSize: 18.0, letterSpacing: 0.15, fontStyle: FontStyle.italic),
          subtitle2: TextStyle(
              fontSize: 16.0, letterSpacing: 0.1, fontStyle: FontStyle.italic),
        ),
      ),
      home: AutomaticConnectionScreen(),
    );
  }
}
