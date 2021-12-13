import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class mainMenu extends StatefulWidget {
  const mainMenu({key}) : super(key: key);

  @override
  _mainMenuState createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu> {
  List <String> items= ['Installing software','Uninstalling software','Customization', 'Cleaning', 'Optimization','Command Console'];


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
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                            final item = items[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton.icon(
                                onPressed: () async {},
                                icon: Icon(Icons.navigate_next),
                                label: Text(
                                  items[index],
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
                              },
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
    );
  }
}
