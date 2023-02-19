import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usim_attendance_app/DataLayer/Model/Firestore/UserModel/UserModel.dart';

import '../../../../Bloc/Auth/auth_bloc.dart';
import '../../../../Bloc/BlocBasedOnPages/MainPageAdminBloc/main_page_admin_bloc.dart';
import '../../../../DataLayer/Model/Firestore/LabModel/LabModel.dart';
import '../../Authentication/Login.dart';
import '../ListLab/ListLabScreen.dart';
import '../UserAdminAndStudent/AdminandStudent.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
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
    return Card(
      // color: const Color.fromARGB(255, 64, 224, 208),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 1,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Browse",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
            SizedBox(

              child: gridView(context),
            )
          ],
        ),
      ),
    );
  }
}

Widget gridView(BuildContext context) {
  return GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    crossAxisSpacing: 10,
    scrollDirection: Axis.vertical,
    mainAxisSpacing: 10,
    children: List<Widget>.generate(3, (index) {
      return GridTile(
        child: InkWell(
          onTap: () {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListLabScreen()),
                );
                break;
              case 1:
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const CategoryScreen()),
                // );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminAndStudentScreen()),
                );
                break;

            }
          },
          child: Card(
              color: (index == 0)
                  ? const Color.fromARGB(255, 64, 224, 208)
                  : (index == 1)
                      ? const Color.fromARGB(255, 90, 200, 250)
                      : const Color.fromARGB(255, 120, 190, 255)
                         ,
              child: Center(
                child: (index == 0)
                    ? const Text(
                        "Labs",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    : (index == 1)
                        ? const Text(
                            "Equipments",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        : const Text(
                                "Users",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                           ,
              )),
        ),
      );
    }),
  );
}
