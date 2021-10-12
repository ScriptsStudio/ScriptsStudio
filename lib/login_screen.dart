import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:network_info_plus/network_info_plus.dart';

late List ipsList = [
  '192.168.1.2',
  '192.168.1.3',
  '192.168.1.4',
  '192.168.1.5',
  '192.168.1.6',
  '192.168.1.7',
  '192.168.1.8',
  '192.168.1.9',
  '192.168.1.10'
];
late List hostnameList = [
  'PC de David',
  'MacBook',
  'Windows-SSD',
  'Windows 10',
  'Ubuntu-20',
  'Arch Linux',
  'Mac Mini',
  'Windows 11',
  'MSI-Axel',
  '1',
  '1',
  '2',
  '1'
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    scanNetwork();
    super.initState();
  }

  Future<void> scanNetwork() async {
    await (NetworkInfo().getWifiIP()).then(
      (ip) async {
        final String subnet = ip!.substring(0, ip.lastIndexOf('.'));
        const port = 22;
        for (var i = 0; i < 256; i++) {
          String ip = '$subnet.$i';
          await Socket.connect(ip, port, timeout: Duration(milliseconds: 50))
              .then((socket) async {
            await InternetAddress(socket.address.address)
                .reverse()
                .then((value) {
              setState(() {
                ipsList.add(socket.address.address);
                hostnameList.add(value.host);
                print(socket.address.address);
                print(value.host);
              });
            }).catchError((error) {
              print(socket.address.address);
              print('catchError InternetAddress: $error');
            });
            socket.destroy();
          }).catchError((error) {
            print('catchError Socket.connect' + error.toString());
          });
        }
      },
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
                          padding: const EdgeInsets.only(left: 20.0,top: 20.0,right: 20.0),
                          child: Text('Automatic connection',
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextButton(onPressed: null, child: Text("Can't find your device? Enter it manually",style: TextStyle(color: Colors.redAccent),)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GridView.count(
                                  crossAxisCount: 3,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  crossAxisSpacing:2,
                                  mainAxisSpacing: 2,
                                  children:
                                      List.generate(ipsList.length, (index) {
                                    return Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(30.0),
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
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: CircleAvatar(
                                                  child: Icon(
                                                    Icons.computer,
                                                    color: Colors.white,
                                                  ),
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                            ListTile(
                                              title: Text(hostnameList[index],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1),
                                              subtitle: Text(ipsList[index],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2),
                                            ),
                                          ],
                                        ));
                                  }))),
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
