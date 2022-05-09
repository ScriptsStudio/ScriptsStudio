import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scriptstudio/loginScreens.dart';

import 'globalVariables.dart';
import 'languajes.dart';

class listBloatwareScreen extends StatefulWidget {
  const listBloatwareScreen({key}) : super(key: key);

  @override
  _listBloatwareScreenState createState() => _listBloatwareScreenState();
}

class _listBloatwareScreenState extends State<listBloatwareScreen> {
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
                          child: Text(AppLocalizations.of(context)
                              .translate('selectedApplications'),
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 1.60,
                          child: new ListView.builder(
                              itemCount: bloatwareSelected.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                String keyMap = bloatwareSelected.keys
                                    .elementAt(index);
                                String valuesMap = bloatwareSelected
                                    .values
                                    .elementAt(index);
                                return Column(children: [
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
                                                        bloatwareSelected
                                                            .remove(keyMap);
                                                      });
                                                      Scaffold.of(context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text(keyMap +AppLocalizations.of(context)
                                                            .translate('removeListSnackBar')),
                                                        duration: Duration(
                                                            seconds: 3),
                                                      ));
                                                    },
                                                    child: Text(AppLocalizations.of(context)
                                                        .translate('deleteButton'),
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
                              }),
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
                                if (bloatwareSelected.isNotEmpty) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  String appsConcatena;
                                  appsConcatena =
                                      bloatwareSelected.values.join(' ');
                                  String command;
                                  if (system == 'Linux') {
                                    command =
                                        'echo ${passwordSSH} | sudo -S python3 .ScriptsStudio/bloatware.py ${appsConcatena}';
                                  } else {
                                    command =
                                        'python.exe \$Env:USERPROFILE\\ScriptsStudio\\bloatware.py ${appsConcatena} ';
                                  }
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context)
                                        .translate('startUninstallerSnackBar')),
                                    duration: Duration(seconds: 3),
                                  ));
                                  await onConnectToPCSSH(ipAddress, portSSH, userSSH, passwordSSH, command);
                                  setState(() {
                                    isLoading = false;
                                    bloatwareSelected.clear();
                                  });
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content:
                                        Text(AppLocalizations.of(context)
                                            .translate('endUninstalleSnackBar')),
                                    duration: Duration(seconds: 3),
                                  ));
                                } else {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context)
                                        .translate('listAppEmptyUninstallSnackBar')),
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
                                  :  Text(AppLocalizations.of(context)
                                  .translate('uninstallButton')),
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
