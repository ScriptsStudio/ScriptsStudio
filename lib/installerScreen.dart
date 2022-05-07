import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scriptstudio/languajes.dart';
import 'globalVariables.dart';
import 'listAppScreen.dart';
import 'loginScreens.dart';

class installerScreen extends StatefulWidget {
  const installerScreen({key}) : super(key: key);

  @override
  _installerScreenState createState() => _installerScreenState();
}

class _installerScreenState extends State<installerScreen> {
  @override
  void initState() {
    super.initState();
    String command;

    if (system == 'Windows') {
      command =
          "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))";
      onConnectToPCSSH(ipAddress, portSSH, userSSH, passwordSSH, command);
    }
    if (system == 'Linux') {
      command =
          "echo ${passwordSSH} | sudo -S wget 'https://github.com/AleixMT/Linux-Auto-Customizer/archive/refs/heads/master.zip' -P \${HOME} --output-document Customizer.zip ; sudo unzip \${HOME}/Customizer.zip -d \${HOME}/ ; sudo mv *Customizer* \${HOME}/.ScriptsStudio/ ; sudo bash \${HOME}/.ScriptsStudio/Linux-Auto-Customizer-master/src/core/install.sh -v -o -k customizer ";
      onConnectToPCSSH(ipAddress, portSSH, userSSH, passwordSSH, command);
    }
  }

  final db = FirebaseFirestore.instance;

  List<String> developersNick = ['XRuppy', 'Axlfc'];
  List<String> systemsList = ['Windows', 'Linux'];

  Widget listsAppsWidget(String data, String filter, String title) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 20.0, right: 20.0, bottom: 10),
            child: Text(title, style: Theme.of(context).textTheme.subtitle2),
          ),
          StreamBuilder(
            stream: db
                .collection('Applications')
                .where(filter, isEqualTo: data)
                .where('system', arrayContains: system)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                    strokeWidth: 1.5,
                  ),
                );
              }
              List<DocumentSnapshot> docs = snapshot.data.docs;
              return Container(
                height: 150,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    Map<String, dynamic> data = docs[i].data();
                    print(data);
                    return Container(
                        width: 150,
                        child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 6,
                            shadowColor: Colors.black,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                            data['logo'].toString()),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(data['nameDisplay'],
                                    style: Theme.of(context).textTheme.caption),
                                ElevatedButton(
                                  child: Text(
                                      AppLocalizations.of(context)
                                          .translate('selectButton'),
                                      style:
                                          Theme.of(context).textTheme.button),
                                  onPressed: () {
                                    print(data['nameDisplay']);
                                    applicationsSelected[data['nameDisplay']] =
                                        data['name' + system];
                                    print(applicationsSelected);

                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(data['nameDisplay'] +
                                          AppLocalizations.of(context)
                                              .translate('snackBarAddAppList')),
                                      duration: Duration(seconds: 2),
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.redAccent,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ],
                            )));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var categoriesAppsWindows = {
      'Productivity':
          AppLocalizations.of(context).translate('categoryAppProductivity'),
      'Social': AppLocalizations.of(context).translate('categoryAppSocial'),
      'Utilities':
          AppLocalizations.of(context).translate('categoryAppUtilities'),
      'Entertainment':
          AppLocalizations.of(context).translate('categoryAppEntertainment'),
      'Games': AppLocalizations.of(context).translate('categoryAppGames'),
      'Development':
          AppLocalizations.of(context).translate('categoryAppDevelopment'),
      'Security': AppLocalizations.of(context).translate('categoryAppSecurity'),
      'Photo and Video':
          AppLocalizations.of(context).translate('categoryAppPhoto&Video'),
      'Music and Audio':
          AppLocalizations.of(context).translate('categoryAppMusic&Audio'),
      'Art and Design':
          AppLocalizations.of(context).translate('categoryAppArt&Design'),
    };

    var categoriesAppsLinux = {
      'Productivity':
          AppLocalizations.of(context).translate('categoryAppProductivity'),
      'Social': AppLocalizations.of(context).translate('categoryAppSocial'),
      'Utilities':
          AppLocalizations.of(context).translate('categoryAppUtilities'),
      'Entertainment':
          AppLocalizations.of(context).translate('categoryAppEntertainment'),
      'Games': AppLocalizations.of(context).translate('categoryAppGames'),
      'Development':
          AppLocalizations.of(context).translate('categoryAppDevelopment'),
      'Security': AppLocalizations.of(context).translate('categoryAppSecurity'),
      'Photo and Video':
          AppLocalizations.of(context).translate('categoryAppPhoto&Video'),
      'Music and Audio':
          AppLocalizations.of(context).translate('categoryAppMusic&Audio'),
      'Art and Design':
          AppLocalizations.of(context).translate('categoryAppArt&Design'),
      'Functions':
          AppLocalizations.of(context).translate('categoryAppFunctions'),
      'Git Functions':
          AppLocalizations.of(context).translate('categoryAppGitFunctions'),
      'Wrappers': AppLocalizations.of(context).translate('categoryAppWrappers'),
    };

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.min,
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
                Container(
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
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 12, right: 12, left: 12),
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 20.0, right: 20.0),
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate('installerTitle'),
                                  style: Theme.of(context).textTheme.subtitle1),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 5.0, right: 10.0),
                              child: TextButton(
                                  onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                listAppScreen()),
                                      ),
                                  child: Text(
                                    'Ver las apps seleccionadas',
                                    style: TextStyle(color: Colors.redAccent),
                                  )),
                            ),
                            listsAppsWidget(
                                'XRuppy',
                                'recomendedBy',
                                AppLocalizations.of(context)
                                    .translate('ourRecommendations')),
                            if (system == 'Windows')
                              for (var i = 0;
                                  i < categoriesAppsWindows.length;
                                  i++)
                                listsAppsWidget(
                                    categoriesAppsWindows.keys.elementAt(i),
                                    'tag',
                                    categoriesAppsWindows.values.elementAt(i)),
                            if (system == 'Linux')
                              for (var i = 0;
                                  i < categoriesAppsLinux.length;
                                  i++)
                                listsAppsWidget(
                                    categoriesAppsLinux.keys.elementAt(i),
                                    'tag',
                                    categoriesAppsLinux.values.elementAt(i)),
                          ],
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
