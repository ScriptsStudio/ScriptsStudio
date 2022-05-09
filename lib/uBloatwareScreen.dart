import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scriptstudio/listBloatwareScreen.dart';
import 'globalVariables.dart';
import 'languajes.dart';
import 'listAppScreen.dart';
import 'loginScreens.dart';

class uBloatwareScreen extends StatefulWidget {
  const uBloatwareScreen({key}) : super(key: key);

  @override
  _uBloatwareScreenState createState() => _uBloatwareScreenState();
}

class _uBloatwareScreenState extends State<uBloatwareScreen> {
  @override
  void initState() {
    super.initState();
  }

  final db = FirebaseFirestore.instance;

  Widget listsAppsWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: db.collection('Bloatware').snapshots(),
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
                height: MediaQuery.of(context).size.height / 1.60,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:1.2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    Map<String, dynamic> data = docs[i].data();
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
                                  child: Text(AppLocalizations.of(context).translate('selectButton'),
                                      style:
                                          Theme.of(context).textTheme.button),
                                  onPressed: () {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(data['nameDisplay']+AppLocalizations.of(context).translate('snackBarAddAppList')),
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
                              child: Text(AppLocalizations.of(context).translate('titleBloatwareScreen'),
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
                                                listBloatwareScreen()),
                                      ),
                                  child: Text(AppLocalizations.of(context).translate('viewSelectedAppButton'),
                                    style: TextStyle(color: Colors.redAccent),
                                  )),
                            ),
                            listsAppsWidget(),
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
