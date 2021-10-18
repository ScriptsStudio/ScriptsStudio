import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scriptstudio/automatic_connection_screen.dart';
import 'package:scriptstudio/devicesClass.dart';
import 'languajes.dart';
import 'package:splashscreen/splashscreen.dart';
import 'automatic_connection_screen.dart';
import 'package:libdsm/libdsm.dart';
import 'dart:convert';
import 'dart:io';

List ipsList = [];
List hostnameList = [];
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
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new AutomaticConnectionScreen(),
      title: new Text(
        'ScriptsStudio',
        style: Theme.of(context).textTheme.headline4,
      ),
      image: null,
      loadingText: Text(
        "Loading...",
        style: Theme.of(context).textTheme.button,
      ),
      photoSize: 50.0,
      loaderColor: Colors.white,
      backgroundColor: Colors.red,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //scanNetwork();
    _create();
  }

  List ipsListDraft = [];
  List hostnameListDraft = [];
  Dsm dsm = Dsm();

  void _create() async {
    await dsm.init();
    _startDiscovery();
  }

  void _startDiscovery() async {
    dsm.onDiscoveryChanged.listen(_discoveryListener);
    await dsm.startDiscovery();
  }

  void _discoveryListener(String json) async {
    print('Discovery : $json');
    Device device = Device.fromJson(jsonDecode(cleanerJSON(json)));
    print(device.name);
    hostnameListDraft.add(device.name);
    print(device.address);
    ipsListDraft.add(device.address);
    confirmSSHOn();
  }

  void _stopDiscovery() async {
    dsm.onDiscoveryChanged.listen(null);
    await dsm.stopDiscovery();
  }

  String cleanerJSON(String json) {
    String cleanJson = json.substring(10);
    if (cleanJson != null && cleanJson.length >= 5) {
      cleanJson = cleanJson.substring(0, cleanJson.length - 10);
    }
    return cleanJson;
  }

  Future<void> confirmSSHOn() async {
    const port = 22;
    for (var i = 0; i < ipsListDraft.length; i++) {
      String ip = ipsListDraft[i];
      await Socket.connect(ip, port, timeout: Duration(milliseconds: 50))
          .then((socket) async {
            setState(() {
              if (ipsList.contains(ipsListDraft[i]) == false) {
                ipsList.add(ipsListDraft[i]);
                hostnameList.add(hostnameListDraft[i]);
              }
            });

        socket.destroy();
      }).catchError((error) {
        print('catchError Socket.connect' + error.toString());
      });
    }
    _stopDiscovery();
  }
}
