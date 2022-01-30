import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'globalVariables.dart';
import 'listAppScreen.dart';

class installerScreen extends StatefulWidget {
  const installerScreen({key}) : super(key: key);

  @override
  _installerScreenState createState() => _installerScreenState();
}

class _installerScreenState extends State<installerScreen> {
  @override
  void initState() {
    _choiseIndex = 0;
    super.initState();
  }

  final db = FirebaseFirestore.instance;
  //List<String> applicationsSelected = [];

  List<String> categoriesAppsWindows = [
    'Productivity',
    'Social',
    'Utilities',
    'Entertainment',
    'Games',
    'Development',
    'Security',
    'Photo and Video',
    'Music and Audio',
    'Art and Design',
  ];
  List<String> categoriesAppsLinux = [
    'Productivity',
    'Social',
    'Utilities',
    'Entertainment',
    'Games',
    'Development',
    'Security',
    'Photo and Video',
    'Music and Audio',
    'Art and Design',
    'Functions',
    'GitFunctions',
    'Wrappers'
  ];
  String systemSelected = 'Windows';
  List<String> developersNick = ['XRuppy', 'Axlfc'];
  List<String> systemsList = ['Windows', 'Linux'];
  int _choiseIndex;

  Widget _buildChoiceChips() {
    return Container(
      height: MediaQuery.of(context).size.height / 8,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: systemsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(systemsList[index]),
              selected: _choiseIndex == index,
              selectedColor: Colors.redAccent,
              onSelected: (bool selected) {
                setState(() {
                  _choiseIndex = selected ? index : 0;
                  systemSelected = systemsList[index];
                });
              },
              backgroundColor: Colors.black12,
              labelStyle: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget listsAppsWidget(String data, String filter, String title) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: Text(title + data,
                style: Theme.of(context).textTheme.subtitle2),
          ),
          StreamBuilder(
            stream: db
                .collection('Applications')
                .where(filter, isEqualTo: data)
                .where('system', arrayContains: systemSelected)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
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
                                  child: Text('SELECT',
                                      style:
                                          Theme.of(context).textTheme.button),
                                  onPressed: () {
                                    print(data['nameDisplay'] + 'hola');
                                    applicationsSelected[data['nameDisplay']] =
                                        data['name' + systemSelected];
                                    print(applicationsSelected);
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Se ha añadido ${data['nameDisplay']} a la lista"),
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
    return Scaffold(
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
                              child: Text('Installer',
                                  style: Theme.of(context).textTheme.subtitle1),
                            ),
                            TextButton(
                                onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              listAppScreen()),
                                    ),
                                child: Text('Ver las apps seleccionadas')),
                            _buildChoiceChips(),
                            for (var nick in developersNick)
                              listsAppsWidget(
                                  nick, 'recomendedBy', 'Recommended by '),
                            if (systemSelected == 'Windows')
                              for (var category in categoriesAppsWindows)
                                listsAppsWidget(category, 'tag', ''),
                            if (systemSelected == 'Linux')
                              for (var category in categoriesAppsLinux)
                                listsAppsWidget(category, 'tag', ''),
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
