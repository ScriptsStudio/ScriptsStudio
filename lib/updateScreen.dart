import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scriptstudio/installerScreen.dart';
import 'package:scriptstudio/uBloatwareScreen.dart';
import 'globalVariables.dart';
import 'languajes.dart';
import 'listAppScreen.dart';
import 'loginScreens.dart';

class updateScreen extends StatefulWidget {
  const updateScreen({key}) : super(key: key);

  @override
  _updateScreenState createState() => _updateScreenState();
}
List<bool> checkBoxesCheckedStates = [];
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
bool isLoading = false;
class _updateScreenState extends State<updateScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
            setState(() {
        if (system == 'Windows') {
          optionsUpdate = {
            AppLocalizations.of(context).translate('updateSystemSwitch'): //Actualizar sistema operativo
            "Set-ExecutionPolicy Unrestricted -Force ; Install-Module PSWindowsUpdate -Confirm:\$False -Force ; Import-Module PSWindowsUpdate ; Install-WindowsUpdate -AcceptAll -Install -IgnoreReboot",
            AppLocalizations.of(context).translate('updateSoftwareSwitch'): "choco update all -y -f", //Actualizar programario
          };
        }
        if (system == 'Linux') {
          optionsUpdate = {
            AppLocalizations.of(context).translate('updateSystemSwitch'):
            "echo ${passwordSSH} | sudo -S apt update -y ; sudo -S apt upgrade -y ; sudo -S apt dist-upgrade",
             AppLocalizations.of(context).translate('updateRepositorySwitch')://Actualizar repositorios
          "echo ${passwordSSH} | sudo -S apt update -y",
            AppLocalizations.of(context).translate('updateSoftwareSwitch'):
            "echo ${passwordSSH} | sudo -S apt update -y ; sudo -S apt upgrade -y",
          };
        };

      });
            for (int i = 0; i <= optionsUpdate.length; i++){
              checkBoxesCheckedStates.add(false);
            }

    });
  }

  var optionsUpdate = {};
  String commandFinal = '';
  Widget buttonMain(String textScreen, String command,int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CheckboxListTile(
        activeColor: Colors.redAccent,
        title: Text(textScreen),
        value:  checkBoxesCheckedStates[index],
        onChanged: (bool newValue) {
          setState(() {
            if (newValue == true){
              commandFinal = commandFinal + command + ' ; ';
            }else{
              commandFinal = '';
            }
              checkBoxesCheckedStates[index]  = newValue;
          });
        },
        secondary: const Icon(Icons.update_outlined),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
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
          Expanded(
            child: Stack(
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
                          offset:
                              Offset(0, 3), // changes position of shadow
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
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('titleUpdateScreen'),
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0,
                              top: 10.0,
                              right: 20.0,
                              bottom: 40),
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('titleWhatDoYouWantToDo'),
                              style: Theme.of(context).textTheme.subtitle2),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 1.80,
                          child: new ListView.builder(
                              itemCount: optionsUpdate.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return Column(
                                    children: [
                                      buttonMain(
                                          optionsUpdate.keys
                                              .elementAt(index),
                                          optionsUpdate.values
                                              .elementAt(index),index),
                                    ]);
                              }),
                        ),Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 70,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent,
                                  minimumSize: Size(double.infinity, 50),
                                  shape: StadiumBorder()),
                              onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(AppLocalizations.of(context).translate('startUpdateSnackBar')),
                                    duration: Duration(seconds: 3),
                                  ));
                                  print('COMMAND EXEC'+ commandFinal);
                                  await onConnectToPCSSH(ipAddress, portSSH, userSSH, passwordSSH, commandFinal);
                                  print(result);
                                  setState(() {
                                    isLoading = false;
                                    applicationsSelected.clear();
                                  });
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content:
                                    Text(AppLocalizations.of(context).translate('endUpdateSnackBar')),
                                    duration: Duration(seconds: 3),
                                  ));

                              },
                              child: (isLoading)
                                  ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1.5,
                                  ))
                                  :  Text(AppLocalizations.of(context).translate('updateButton')),
                            ),
                          ),
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
