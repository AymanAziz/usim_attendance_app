import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../../Bloc/Auth/auth_bloc.dart';
import '../../Authentication/Login.dart';
import 'package:huawei_safetydetect/huawei_safetydetect.dart';


class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  getMaliciousAppsList(BuildContext context) {
    runZoned(() async {
      List<MaliciousAppData> maliciousApps;
      maliciousApps = await SafetyDetect.getMaliciousAppsList();
      String maliciousAppsResult = maliciousApps.isEmpty
          ? "No malicious apps detected."
          : "Malicious Apps:$maliciousApps";
      if (kDebugMode) {
        print(maliciousAppsResult);
      }
    if(!mounted) return;
      showSuccessAlert(context, maliciousAppsResult);
    }, onError: (error, stackTrace) {

      showErrorAlert(context, error.toString());
    });
  }

  showSuccessAlert(BuildContext context, String message) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Success",
      desc: message,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }
  showErrorAlert(BuildContext context, String message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Error",
      desc: message,
      buttons: [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          width: 120,
          child: const Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ).show();
  }

  final providerID = FirebaseAuth.instance.currentUser!.providerData.first.providerId;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child:SafeArea(child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('About'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is UnAuthenticated) {
              // Navigate to the sign in screen when the user Signs Out
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
              );
            }
          },
          child:ListView(
            children:  [
              GestureDetector(
                onTap: (){
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) =>  const ProfilePage()),
                  //
                  // );
                },
                child: const Card(
                  child: ListTile(title: Text('Profile'),),
                ),
              ),//user profile
              userListView(providerID,context),//change password
              GestureDetector(
                onTap: (){
                  _showDialog(context);
                },
                child: const Card(
                  child: ListTile(title: Text('Logout'),),
                ),
              )//logout

            ],
          ), ),

      ),

      ),
    );
  }
  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Expanded(
              child: AlertDialog(
                title: const Text('Log Out'),
                content: const Text('Do you  want to Log Out?'),
                actions: [
                  TextButton(
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                    child: const Text('NO', style: TextStyle(color: Colors.black),),
                  ),
                  TextButton(
                    onPressed: () {
                      // Signing out the user
                      context.read<AuthBloc>().add(SignOutRequested());
                      //Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                              const Login()),
                              (Route<dynamic> route) => false);
                    },
                    child: const Text('YES', style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

Widget userListView(providerID,context)
{
  if (providerID == "password")
  {
    return  GestureDetector(
      onTap: (){
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) =>  const ChangePassword()),
        //
        // );
      },
      child: const Card(
        child: ListTile(title: Text('Change Password'),),
      ),
    );//change password;
  }
  else
  {
    return Container();
  }
}