import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:libdsm/libdsm.dart';
import 'package:scriptstudio/mainMenu.dart';
import 'package:splashscreen/splashscreen.dart';
import 'globalVariables.dart';
import 'loginScreens.dart';
import 'devicesClass.dart';

List ipsListDraft = [];
List hostnameListDraft = [];
Dsm dsm = Dsm();

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

Future<Widget> loadFromFuture() async {
  _create();
  await Future.delayed(Duration(seconds: 1));
  if (ipsList.isEmpty) {
    return Future.value(new manual_Connection_Screen());
  } else {
    return Future.value(new AutomaticConnectionScreen());
  }
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterFuture: loadFromFuture(),
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
}

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
      if (ipsList.contains(ipsListDraft[i]) == false) {
        ipsList.add(ipsListDraft[i]);
        hostnameList.add(hostnameListDraft[i]);
      }
      socket.destroy();
    }).catchError((error) {
      print('catchError Socket.connect' + error.toString());
    });
  }
  _stopDiscovery();
}
