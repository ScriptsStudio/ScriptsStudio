import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

late List ipsList = [];
late List hostnameList = [];


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
            await InternetAddress(socket.address.address).reverse().then((value) {
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
          }).catchError((error)  {
            print('catchError Socket.connect'+error.toString());
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Manual connection',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Automatic connection',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.builder(
                          itemCount: ipsList.length,
                          itemBuilder: (context, index) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                                elevation: 2,
                                shadowColor: Colors.black,
                                color: Colors.white70,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(hostnameList[index]),
                                      subtitle: Text(ipsList[index]),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ButtonBar(
                                          children: [
                                            IconButton(
                                              onPressed: null,
                                              icon: Icon(Icons.add_circle_outline),
                                              color: Colors.redAccent,tooltip: 'Connect to host',
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
