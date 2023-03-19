import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usim_attendance_app/DataLayer/Model/Firestore/UserModel/UserModel.dart';

import '../../../../Bloc/Auth/auth_bloc.dart';
import '../../../../Bloc/BlocBasedOnPages/MainPageAdminBloc/main_page_admin_bloc.dart';
import '../../../../DataLayer/Model/Firestore/LabModel/LabModel.dart';
import '../../Authentication/Login.dart';
import '../ListEquipment/ListLabEquipmentScreen.dart';
import '../ListLab/ListLabScreen.dart';
import '../UserAdminAndStudent/AdminandStudent.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Color color = const Color(0x0040e0d0);

  final MainPageAdminBloc mainPageAdminBloc = MainPageAdminBloc();

  @override
  void initState() {
    mainPageAdminBloc.add(const MainPageBloc());
    super.initState();
  }

  ///refresh
  Future<void> refresh() {
    return refreshBloc().then((value) => setState(() {}));
  }

  Future<void> refreshBloc() async {
    mainPageAdminBloc.add(const MainPageBloc());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                tooltip: "Pull to refresh",
                icon: const Icon(Icons.info_outline_rounded),
                color: const Color.fromARGB(255, 4, 52, 84),
                onPressed: () {},
              );
            },
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<MainPageAdminBloc>(
              create: (context) => mainPageAdminBloc),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(listener: (context, state) async {
              if (state is UnAuthenticated) {
                // Navigate to the sign in screen when the user Signs Out
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                );
              }
            }),
          ],
          child: BlocBuilder<MainPageAdminBloc, MainPageAdminState>(
              builder: (context, state) {
            if (state is MainPageAdminLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MainPageLoad) {
              List<UserModel> student =  state.listUsersValue.where((element) => element.isAdmin == false).toList();
              List<UserModel> admin =  state.listUsersValue.where((element) => element.isAdmin == true).toList();

              return RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView(
                    children: [
                     Padding(padding: const EdgeInsets.symmetric(horizontal: 20),child:  countAllValues(
                         state.listLabModel,
                        admin,
                       student
                         ),),
                      Padding(padding:  const EdgeInsets.symmetric(horizontal: 20), child:browse(
                          state.listLabModel,
                          admin,
                          student),)
                    ],
                  ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    ));
  }

  Widget countAllValues(
      List<LabModel> listLabModel,
      List<UserModel> listUserModelAdmin,
      List<UserModel> listUserModelStudent) {
    return Card(
      // color: const Color.fromARGB(255, 64, 224, 208),
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Information",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
            SizedBox(
              height: 120,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 64, 224, 208),
                            Colors.blue,
                          ],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 0,
                            shadowColor: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(listLabModel.length.toString(),style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                fontSize: 25)),
                                const Text("Lab",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),

                              ],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xff7b4397),
                            Color(0xffdc2430)

                            ,
                          ],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) =>  const AcknowledgmentDeliveryDenied()));
                        },
                        child: Card(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 0,
                            shadowColor: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(listUserModelStudent.length.toString(),style: const TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                                const Text("Student",
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontWeight: FontWeight.bold)),

                              ],
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xffff7e5f),
                            Color(0xfffeb47b),
                          ],
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) =>  const AcknowledgmentDeliveryApproved()));
                        },
                        child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            shadowColor: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(listUserModelAdmin.length.toString(),style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                                const Text("Admin",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),

                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget browse(
      List<LabModel> listLabModel,
      List<UserModel> listUserModelAdmin,
      List<UserModel> listUserModelStudent) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Browse",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
          gridView(context)
        ],
      ),
    );
  }
}

Widget gridView(BuildContext context) {


  return CarouselSlider(
    items: [
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => const ListLabScreen()) );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                   const Icon(
                    Icons.science,
                    size: 72,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Discover Laboratory",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Find and manage labs with ease",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ListLabEquipmentScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.handyman,
                    size: 72,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manage Equipment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Add, delete or update equipment in your lab",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminAndStudentScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Row(
                children: [
                  const Icon(
                    Icons.person ,
                    size: 72,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Manage Users",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Control user access and permissions with ease",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
    options: CarouselOptions(
      height: 155,
      autoPlay: true,
      enlargeCenterPage: true,
      aspectRatio: 3,
      viewportFraction: 0.8,

    ),
  );
}
