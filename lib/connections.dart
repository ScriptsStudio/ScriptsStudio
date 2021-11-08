import 'dart:io';
import 'dart:convert';
import 'devicesClass.dart';
import 'package:ssh2/ssh2.dart';
import 'package:libdsm/libdsm.dart';
import 'package:flutter/material.dart';


List ipsList = [];
List hostnameList = [];

class AutomaticConnectionScreen extends StatefulWidget {
  const AutomaticConnectionScreen({Key key}) : super(key: key);

  @override
  _AutomaticConnectionScreenState createState() =>
      _AutomaticConnectionScreenState();
}

class _AutomaticConnectionScreenState extends State<AutomaticConnectionScreen> {
  TextEditingController userSSH;
  TextEditingController passwordSSH;
  @override
  void initState() {
    super.initState();
    _create();
    userSSH = TextEditingController(text: 'root');
    if (ipsList.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => manual_Connection_Screen()),
      );
    }
  }

  @override
  void dispose() {
    userSSH.dispose();
    passwordSSH.dispose();
    super.dispose();
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
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 20.0, right: 20.0),
                          child: Text('Automatic connection',
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: TextFormField(
                                      controller: userSSH,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          labelText: 'User',
                                          icon: Icon(
                                            Icons.supervised_user_circle,
                                            color: Colors.redAccent,
                                          )),
                                    ))),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextFormField(
                                    controller: passwordSSH,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        icon: Icon(
                                          Icons.password,
                                          color: Colors.redAccent,
                                        )),
                                  )),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextButton(
                              onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            manual_Connection_Screen()),
                                  ),
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
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
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

  List ipsListDraft = [];
  List hostnameListDraft = [];
  Dsm dsm = Dsm();

  void _create() async {
    await dsm.init();
    _startDiscovery();
  }

  void _startDiscovery() async {
    dsm.onDiscoveryChanged.listen(_discoveryListener);
    await dsm.startDiscovery();
  }

  void _discoveryListener(String json) async {
    print('Discovery : $json');
    Device device = Device.fromJson(jsonDecode(cleanerJSON(json)));
    print(device.name);
    hostnameListDraft.add(device.name);
    print(device.address);
    ipsListDraft.add(device.address);
    confirmSSHOn();
  }

  void _stopDiscovery() async {
    dsm.onDiscoveryChanged.listen(null);
    await dsm.stopDiscovery();
  }

  String cleanerJSON(String json) {
    String cleanJson = json.substring(10);
    if (cleanJson != null && cleanJson.length >= 5) {
      cleanJson = cleanJson.substring(0, cleanJson.length - 10);
    }
    return cleanJson;
  }

  Future<void> confirmSSHOn() async {
    const port = 22;
    for (var i = 0; i < ipsListDraft.length; i++) {
      String ip = ipsListDraft[i];
      await Socket.connect(ip, port, timeout: Duration(milliseconds: 50))
          .then((socket) async {
        setState(() {
          if (ipsList.contains(ipsListDraft[i]) == false) {
            ipsList.add(ipsListDraft[i]);
            hostnameList.add(hostnameListDraft[i]);
          }
        });

        socket.destroy();
      }).catchError((error) {
        print('catchError Socket.connect' + error.toString());
      });
    }
    _stopDiscovery();
  }
}

class manual_Connection_Screen extends StatefulWidget {
  const manual_Connection_Screen({key}) : super(key: key);
  @override
  _manual_Connection_ScreenState createState() =>
      _manual_Connection_ScreenState();
}

class _manual_Connection_ScreenState extends State<manual_Connection_Screen> {
  final myController = TextEditingController();
  TextEditingController ipAddress;
  TextEditingController portSSH;
  TextEditingController userSSH;
  TextEditingController passwordSSH;

  @override
  void initState() {
    super.initState();
    ipAddress = TextEditingController(text: '192.168.1.X');
    portSSH = TextEditingController(text: '22');
    userSSH = TextEditingController(text: 'root');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ipAddress.dispose();
    portSSH.dispose();
    userSSH.dispose();
    passwordSSH.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Text('Logo'),
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
          Flexible(
            flex: 1,
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 20.0, right: 20.0),
                          child: Text('Manual connection',
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 26.0, left: 16.0, bottom: 26.0),
                                    child: SizedBox(
                                      child: TextFormField(
                                        controller: ipAddress,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            labelText: 'IP',
                                            icon: Icon(
                                              Icons.computer,
                                              color: Colors.redAccent,
                                            )),
                                      ),
                                    ))),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 26.0,
                                      right: 16,
                                      left: 20,
                                      bottom: 26.0),
                                  child: TextFormField(
                                    controller: portSSH,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Port',
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0,
                                        right: 10,
                                        left: 20,
                                        bottom: 26.0),
                                    child: TextFormField(
                                      controller: userSSH,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          labelText: 'User',
                                          icon: Icon(
                                            Icons.supervised_user_circle,
                                            color: Colors.redAccent,
                                          )),
                                    ))),
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      right: 16,
                                      left: 10,
                                      bottom: 26.0),
                                  child: TextFormField(
                                    controller: passwordSSH,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        icon: Icon(
                                          Icons.password,
                                          color: Colors.redAccent,
                                        )),
                                  )),
                            ),
                          ],
                        ),
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.all(26.0),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              ipsList.add(ipAddress.text);

                              var client = SSHClient(
                                host: ipAddress.text,
                                port: int.parse(portSSH.text),
                                username: userSSH.text,
                                passwordOrKey: passwordSSH.text,
                              );
                              await client.connect();
                            },
                            icon: Icon(Icons.navigate_next),
                            label: Text(
                              'Connect to PC ',
                              style: Theme.of(context).textTheme.button,
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                )),
                          ),
                        ))
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

  Future<void> checkConnectionHost(List ipAddressList, int port) async {
    for (var i = 0; i < ipAddressList.length; i++) {
      String ip = ipAddressList[i];
      await Socket.connect(ip, port, timeout: Duration(milliseconds: 50))
          .then((socket) async {
        socket.destroy();
        return true;
      }).catchError((error) {
        print('catchError Socket.connect' + error.toString());
        return false;
      });
    }
  }
}
