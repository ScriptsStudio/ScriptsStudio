import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scriptstudio/loginScreens.dart';

import 'globalVariables.dart';

class listAppScreen extends StatefulWidget {
  const listAppScreen({key}) : super(key: key);

  @override
  _listAppScreenState createState() => _listAppScreenState();
}

class _listAppScreenState extends State<listAppScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: SvgPicture.asset('assets/logo_ScriptsStudio.svg'),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 40.0),
                child: Text('ScriptsStudio',
                    style: Theme.of(context).textTheme.headline4),
              ),
            ],
          ),
          Expanded(
            child: Stack(
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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('Aplicaciones seleccionadas',
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 1.60,
                          child: new Expanded(
                              child: new ListView.builder(
                                  itemCount: applicationsSelected.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String keyMap = applicationsSelected.keys
                                        .elementAt(index);
                                    print(keyMap + 'mia');
                                    String valuesMap = applicationsSelected
                                        .values
                                        .elementAt(index);
                                    print(valuesMap + 'nia');
                                    return Column(children: [
                                      // new Text(applicationsSelected[keyMap]),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  title: Text(keyMap),
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            applicationsSelected
                                                                .remove(keyMap);
                                                          });
                                                          Scaffold.of(context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                                "Se ha eliminado ${keyMap} correctamente de la lista"),
                                                            duration: Duration(
                                                                seconds: 3),
                                                          ));
                                                        },
                                                        child: Text(
                                                          'ELIMINAR',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .redAccent),
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]);
                                  })),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: StadiumBorder()),
                              onPressed: () async {
                                if (applicationsSelected.isNotEmpty) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  String appsConcatena;
                                  appsConcatena =
                                      applicationsSelected.values.join(' ');
                                  String command;
                                  if (system == 'Linux') {
                                    command =
                                        'echo ${passwordSSH} | sudo -S python3 .ScriptsStudio/install.py ${appsConcatena}';
                                  } else {
                                    command =
                                        'python.exe \$Env:USERPROFILE\\ScriptsStudio\\install.py ${appsConcatena} ';
                                  }
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text("Iniciando instalación..."),
                                    duration: Duration(seconds: 3),
                                  ));
                                  result = await client.execute(command) ??
                                      'Null result';
                                  print(result);
                                  setState(() {
                                    isLoading = false;
                                    applicationsSelected.clear();
                                  });
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text("Ha finalizado la instalación"),
                                    duration: Duration(seconds: 3),
                                  ));
                                } else {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "No hay ninguna aplicación para instalar"),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                              },
                              child: (isLoading)
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 1.5,
                                      ))
                                  : const Text('INSTALAR'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
