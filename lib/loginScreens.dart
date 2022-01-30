import 'dart:convert';
import 'dart:io';
import 'package:libdsm/libdsm.dart';
import 'package:scriptstudio/mainMenu.dart';
import 'package:dart_ping/dart_ping.dart';
import 'devicesClass.dart';
import 'globalVariables.dart';
import 'package:ssh2/ssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multi_select_item/multi_select_item.dart';

bool connected = false;
List ipsListDraft = [];
List hostnameListDraft = [];
Dsm dsm = Dsm();

class AutomaticConnectionScreen extends StatefulWidget {
  const AutomaticConnectionScreen({Key key}) : super(key: key);

  @override
  _AutomaticConnectionScreenState createState() =>
      _AutomaticConnectionScreenState();
}

class _AutomaticConnectionScreenState extends State<AutomaticConnectionScreen> {
  TextEditingController userSSH;
  TextEditingController passwordSSH;
  MultiSelectController controller = new MultiSelectController();

  @override
  void initState() {
    super.initState();
    _create();
    userSSH = TextEditingController(text: 'root');
    passwordSSH = TextEditingController();
    controller.disableEditingWhenNoneSelected = true;
    controller.set(ipsList.length);
  }

  @override
  void dispose() {
    userSSH?.dispose();
    passwordSSH?.dispose();
    super.dispose();
  }

  void delete() {
    var list = controller.selectedIndexes;
    list.sort((b, a) =>
        a.compareTo(b)); //reoder from biggest number, so it wont error
    list.forEach((element) {
      ipsList.removeAt(element);
    });

    setState(() {
      controller.set(ipsList.length);
    });
  }

  void selectAll() {
    setState(() {
      controller.toggleAll();
    });
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
                                return InkWell(
                                    onTap: () {},
                                    child: MultiSelectItem(
                                        isSelecting: true,
                                        onSelected: () {
                                          setState(() {
                                            controller.toggle(index);
                                            debugPrint(ipsList[index]);
                                            onConnectToPCSSH(
                                                ipsList[index],
                                                portSSH,
                                                userSSH.text,
                                                passwordSSH.text);
                                            if (connected = true)
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        mainMenu()),
                                              );
                                          });
                                        },
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
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
                                                        const EdgeInsets.only(
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
                                                  title: Text(
                                                      hostnameList[index],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption),
                                                  subtitle: Text(ipsList[index],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption),
                                                ),
                                              ],
                                            ))));
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

class manual_Connection_Screen extends StatefulWidget {
  const manual_Connection_Screen({key}) : super(key: key);
  @override
  _manual_Connection_ScreenState createState() =>
      _manual_Connection_ScreenState();
}

class _manual_Connection_ScreenState extends State<manual_Connection_Screen> {
  TextEditingController ipAddressTEC;
  TextEditingController portSSHTEC;
  TextEditingController userSSHTEC;
  TextEditingController passwordSSHTEC;

  @override
  void initState() {
    super.initState();
    ipAddressTEC = TextEditingController(text: '192.168.1.X');
    portSSHTEC = TextEditingController(text: '22');
    userSSHTEC = TextEditingController(text: 'root');
    passwordSSHTEC = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    ipAddressTEC?.dispose();
    portSSHTEC?.dispose();
    userSSHTEC?.dispose();
    passwordSSHTEC?.dispose();
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
                  backgroundColor: Colors.red,
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
                                        controller: ipAddressTEC,
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
                                    controller: portSSHTEC,
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
                                      controller: userSSHTEC,
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
                                    controller: passwordSSHTEC,
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
                              onConnectToPCSSH(
                                  ipAddressTEC.text,
                                  int.parse(portSSHTEC.text),
                                  userSSHTEC.text,
                                  passwordSSHTEC.text);
                              if (connected = true)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => mainMenu()),
                                );
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

Future<void> onConnectToPCSSH(String ipAddressController, int portController,
    String userSSHController, String passSSHController) async {
  String result;
  ipAddress = ipAddressController;
  portSSH = portController;
  userSSH = userSSHController;
  passwordSSH = passSSHController;
  client = SSHClient(
    host: ipAddress,
    port: portSSH,
    username: userSSH,
    passwordOrKey: passwordSSH,
  );
  try {
    result = await client.connect() ?? 'Null result';
    if (result == "session_connected")
      result = await client.execute('sudo.exeA cleanmgr') ?? 'Null result';

    print(result);
    result = await client.execute("whoami");
    print(result);
    connected = true;
    await client.disconnect();
  } on PlatformException catch (e) {
    String errorMessage = 'Error: ${e.code}\nError Message: ${e.message}';
    result = errorMessage;
    print(errorMessage);
  }
}

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
      if (ipsList.contains(ipsListDraft[i]) == false) {
        ipsList.add(ipsListDraft[i]);
        hostnameList.add(hostnameListDraft[i]);
      }
      socket.destroy();
    }).catchError((error) {
      print('catchError Socket.connect' + error.toString());
    });
  }
  _stopDiscovery();
}

String whichSystemIsForTheTTL() {
  int numPings = 0;
  int ttl;
  final ping = Ping('192.168.68.130',
      count: 2, interval: 1, encoding: Utf8Codec(allowMalformed: true));

  ping.stream.listen((event) {
    while (numPings <= 1) {
      ttl = event.response.ttl;
      numPings++;
    }
    //print(ttl);
    if (ttl != null) {
      if (ttl >= 126 && ttl <= 128) {
        print('Is Windows');
        return 'Windows';
      } else if (ttl >= 63 && ttl <= 65) {
        print('Is Linux');
        return 'Linux';
      } else {
        print('Es otro sistema operativo o se ha cambiado el TTL por defecto');
      }
    } else {
      print(
          'No hay respuesta por parte del sistema, no deja obtener información');
    }
  });
}
