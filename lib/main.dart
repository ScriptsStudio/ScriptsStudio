import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scriptstudio/login_screen.dart';
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
      theme: ThemeData(fontFamily: "Product Sans",visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.red, accentColor: Colors.redAccent,scaffoldBackgroundColor:Colors.red),
      home: LoginScreen(),
    );
  }
}