import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scriptstudio/installerScreen.dart';
import 'package:scriptstudio/uBloatwareScreen.dart';
import 'globalVariables.dart';
import 'listAppScreen.dart';
import 'loginScreens.dart';

class mainMenu extends StatefulWidget {
  const mainMenu({key}) : super(key: key);

  @override
  _mainMenuState createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  @override
  void initState() {
    super.initState();
    String command;

    if (system == 'Windows') {
      command =
          "Invoke-WebRequest -Uri 'https://firebasestorage.googleapis.com/v0/b/scriptsstudio-axlfcxrppy.appspot.com/o/ScriptsStudio.zip?alt=media&token=b5df0cdb-28f5-4580-b3aa-d97527320714' -OutFile \$Env:USERPROFILE'\\ScriptsStudio.zip' ; Expand-Archive -Path \$Env:USERPROFILE'\\ScriptsStudio.zip' -DestinationPath \$Env:USERPROFILE'\\ScriptsStudio\\' ; attrib +h \$Env:USERPROFILE'\\ScriptsStudio' ; Remove-Item -Path \$Env:USERPROFILE'\\ScriptsStudio.zip'";
      onConnectToPCSSH(ipAddress, portSSH, userSSH, passwordSSH, command);
      categoriesButtons = {
        'Installing software': installerScreen(),
        'Uninstalling bloatware': uBloatwareScreen(),
        'Upgrades': listAppScreen(),
      };
    }
    if (system == 'Linux') {
      command =
          "echo ${passwordSSH} | sudo -S wget 'https://firebasestorage.googleapis.com/v0/b/scriptsstudio-axlfcxrppy.appspot.com/o/ScriptsStudio.zip?alt=media&token=b5df0cdb-28f5-4580-b3aa-d97527320714' -P \${HOME} --output-document ScriptsStudio.zip ; sudo unzip \${HOME}/ScriptsStudio.zip -d \${HOME}/ScriptsStudio/ ; mv \${HOME}/ScriptsStudio \${HOME}/.ScriptsStudio ; rm \${HOME}/ScriptsStudio.zip -f";
      onConnectToPCSSH(ipAddress, portSSH, userSSH, passwordSSH, command);
      categoriesButtons = {
        'Installing software': installerScreen(),
        'Upgrades': listAppScreen(),
      };
    }
  }

  var categoriesButtons = {};

  Widget buttonMain(String data, var screenRoute) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return screenRoute;
            }),
          );
        },
        icon: Icon(Icons.navigate_next),
        label: Text(
          data,
          style: Theme.of(context).textTheme.headline6,
        ),
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(300, 50),
            primary: Colors.redAccent,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0),
            )),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text('¿Esta seguro?',
                style: Theme.of(context).textTheme.subtitle1),
            content: Text('¿Quiere cerrar la sesión con el dispositivo?',
                style: Theme.of(context).textTheme.bodyText1),
            actions: <Widget>[
              FlatButton(
                  child: Text("No"),
                  textColor: Colors.redAccent,
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                  child: Text("SÍ"),
                  textColor: Colors.redAccent,
                  onPressed: () {
                    if (system == 'Windows') {
                      String command;
                      command =
                          "Remove-Item -Path \$Env:USERPROFILE'\\ScriptsStudio\' -Force -Recurse";
                      onConnectToPCSSH(
                          ipAddress, portSSH, userSSH, passwordSSH, command);
                    }
                    if (system == 'Linux') {
                      String command;
                      command =
                          "echo ${passwordSSH} | sudo -S rm -R \${HOME}/ScriptsStudio";
                      onConnectToPCSSH(
                          ipAddress, portSSH, userSSH, passwordSSH, command);
                    }
                    Future.delayed(Duration(seconds: 2), () {
                      connected = false;
                      system = null;
                      ipAddress = null;
                      portSSH = null;
                      userSSH = null;
                      passwordSSH = null;
                      applicationsSelected.clear();
                      bloatwareSelected.clear();
                      result = client.disconnect() ?? 'Desconectado';
                      print(result);
                      Navigator.of(context).pop(true);
                    });
                  }),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 40.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child:
                            SvgPicture.asset('assets/logo_ScriptsStudio.svg'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 40.0),
                      child: Text('ScriptsStudio',
                          style: Theme.of(context).textTheme.headline4),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 20.0, right: 20.0),
                              child: Text('Main Menu',
                                  style: Theme.of(context).textTheme.subtitle1),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 10.0, right: 20.0),
                              child: Text('What do you want to do?',
                                  style: Theme.of(context).textTheme.subtitle2),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 4,
                              child: Expanded(
                                flex: 2,
                                child: new ListView.builder(
                                    itemCount: categoriesButtons.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(children: [
                                        buttonMain(
                                            categoriesButtons.keys
                                                .elementAt(index),
                                            categoriesButtons.values
                                                .elementAt(index)),

                                      ]);
                                    }),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton.icon(
                                  onPressed: () async {

                                    if (system == 'Windows') {
                                      String command;
                                      command =
                                      "Remove-Item -Path \$Env:USERPROFILE'\\ScriptsStudio\' -Force -Recurse";
                                      onConnectToPCSSH(
                                          ipAddress, portSSH, userSSH, passwordSSH, command);
                                    }
                                    if (system == 'Linux') {
                                      String command;
                                      command =
                                      "echo ${passwordSSH} | sudo -S rm -R \${HOME}/ScriptsStudio";
                                      onConnectToPCSSH(
                                          ipAddress, portSSH, userSSH, passwordSSH, command);
                                    }
                                    Future.delayed(Duration(seconds: 2), () {
                                      connected = false;
                                      system = null;
                                      ipAddress = null;
                                      portSSH = null;
                                      userSSH = null;
                                      passwordSSH = null;
                                      applicationsSelected.clear();
                                      bloatwareSelected.clear();
                                      result = client.disconnect() ?? 'Desconectado';
                                      print(result);
                                      Navigator.of(context).pop(true);
                                    });

                                  },
                                  icon: Icon(Icons.navigate_next),
                                  label: Text(
                                    'Log out',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      fixedSize:
                                      const Size(300, 50),
                                      primary: Colors.redAccent,
                                      shape:
                                      new RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius
                                            .circular(15.0),
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        ));
  }
}
