import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'main.dart';

class AutomaticConnectionScreen extends StatefulWidget {
  const AutomaticConnectionScreen({Key key}) : super(key: key);

  @override
  _AutomaticConnectionScreenState createState() =>
      _AutomaticConnectionScreenState();
}

class _AutomaticConnectionScreenState extends State<AutomaticConnectionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Text('Logo'),
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
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 20.0, right: 20.0),
                          child: Text('Automatic connection',
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextButton(
                              onPressed: null,
                              child: Text(
                                "Can't find your device? Enter it manually",
                                style: TextStyle(color: Colors.redAccent),
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: GridView.count(
                              crossAxisCount: 3,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: List.generate(ipsList.length, (index) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    elevation: 6,
                                    shadowColor: Colors.black,
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: CircleAvatar(
                                              child: Icon(
                                                Icons.computer,
                                                color: Colors.white,
                                              ),
                                              backgroundColor: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(hostnameList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption),
                                          subtitle: Text(ipsList[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption),
                                        ),
                                      ],
                                    ));
                              })),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
