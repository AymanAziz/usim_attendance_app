import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:usim_attendance_app/PresentationLayer/Screen/OnBoardingScreen/CheckUser.dart';
import 'package:usim_attendance_app/PresentationLayer/Screen/User/NavBar/NavBarStudent.dart';

import '../../../DataLayer/Repository/Sqlite/SqliteRepository.dart';
import '../Admin/NavBar/NavBarAdmin.dart';
import '../Authentication/Login.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Start',
        onFinish: () async  {
         await checkUser(context);
        },
        skipTextButton: const Text('Skip'),
        // trailing: const Text('Skip'),
        background: [
          Image.asset('assets/slide_1.png'),
          Image.asset('assets/slide_2.png'),
        ],
        totalPage: 2,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: const <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Description Text 1'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: const <Widget>[
                SizedBox(
                  height: 480,
                ),
                Text('Description Text 2'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


