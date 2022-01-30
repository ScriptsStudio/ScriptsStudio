import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scriptstudio/installerScreen.dart';

import 'listAppScreen.dart';

class mainMenu extends StatefulWidget {
  const mainMenu({key}) : super(key: key);

  @override
  _mainMenuState createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  List <String> items= ['Installing software','Uninstalling software','Customization', 'Cleaning', 'Optimization','Command Console'];
  var categoriesButtons = {'Installing software': installerScreen(),'Uninstalling software':listAppScreen(),'Customization':listAppScreen(),'Cleaning':listAppScreen(),'Optimization':listAppScreen(),'Command Console':listAppScreen()};

  Widget buttonMain(String data,var screenRoute) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
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
              borderRadius:
              new BorderRadius.circular(15.0),
            )),
      ),
    );
  }

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
                    child: SvgPicture.asset('assets/logo_ScriptsStudio.svg'),
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
                          child: Text('Main Menu',
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10.0, right: 20.0),
                          child: Text('What do you want to do?',
                              style: Theme.of(context).textTheme.subtitle2),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new ListView.builder(
                                itemCount: categoriesButtons.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(children: [
                                    buttonMain(categoriesButtons.keys
                                        .elementAt(index), categoriesButtons.values
                                        .elementAt(index))

                                  ]);
                                })
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
    );
  }
}
