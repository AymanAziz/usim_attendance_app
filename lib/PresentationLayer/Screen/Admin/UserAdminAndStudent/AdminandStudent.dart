import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:usim_attendance_app/Bloc/UserBloc/user_bloc.dart';

import '../../../../Bloc/UserAdminUsimBloc/admin_usim_bloc.dart';
import '../../../../DataLayer/Model/Chart/UserChartModel.dart';
import '../../../../DataLayer/Model/Firestore/UserModel/UserModel.dart';

class AdminAndStudentScreen extends StatefulWidget {
  const AdminAndStudentScreen({Key? key}) : super(key: key);

  @override
  State<AdminAndStudentScreen> createState() => _AdminAndStudentScreenState();
}

class _AdminAndStudentScreenState extends State<AdminAndStudentScreen> {
  UserBloc userBloc = UserBloc();
  AdminUsimBloc adminUsimBloc = AdminUsimBloc();
  late TooltipBehavior _tooltipBehavior;
  bool _isExpanded = false;
  bool _isExpanded1 = false;

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

  ///refresh
  Future<void> refresh() {
    return refreshBloc().then((value) => setState(() {}));
  }
  Future<void> refreshBloc() async {
    userBloc.add(GetListUser());  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    userBloc.add(GetListUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            leading: BackButton(color: Colors.black),
            floating: true,
            snap: true,
            title: Text(
              "Users",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SingleChildScrollView(
              child: BlocProvider(
                create: (context) => userBloc,
                child:
                    BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                  if (state is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UserListLoaded) {
                    List<UserModel> student = state.listUser
                        .where((element) => element.isAdmin == false)
                        .toList();
                    List<UserModel> admin = state.listUser
                        .where((element) => element.isAdmin == true)
                        .toList();
                    List<UserChartModel> chartData = [
                      UserChartModel(
                          user: 'student',
                          count: student.length,
                          color: Colors.blue),
                      UserChartModel(
                          user: 'admin',
                          count: admin.length,
                          color: const Color(0xffdc2430)),
                    ];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 1,
                                shadowColor: Colors.black,
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 0, 20, 20),
                                    child: SfCircularChart(
                                        title: ChartTitle(text: ''),
                                        legend: Legend(
                                            isVisible: true,
                                            toggleSeriesVisibility: true,
                                            position: LegendPosition.bottom,
                                            overflowMode:
                                                LegendItemOverflowMode.wrap,
                                            textStyle:
                                                const TextStyle(fontSize: 12)),
                                        tooltipBehavior: _tooltipBehavior,
                                        series: <DoughnutSeries>[
                                          /// Initialize line series

                                          DoughnutSeries<UserChartModel,
                                              String>(
                                            /// Binding list data to the chart.
                                            dataSource: chartData,
                                            pointColorMapper:
                                                (UserChartModel data, _) =>
                                                    data.color,
                                            xValueMapper:
                                                (UserChartModel sales, _) =>
                                                    sales.user,
                                            enableTooltip: true,
                                            yValueMapper:
                                                (UserChartModel sales, _) =>
                                                    sales.count,
                                          )
                                        ])))),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _uI(context, student, admin))
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
              ),
            )
          ]))
        ],
      ),
    ));
  }

  Widget _uI(BuildContext context, student, admin) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 64, 224, 208),
                Colors.blue,
              ],
            ),
          ),
          // height: screenHeight * 0.20, // 20% of the screen height
          child: Card(
            color: Colors.transparent,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ExpansionTile(
              onExpansionChanged: (expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(color: Colors.transparent)),
              textColor: const Color.fromARGB(255, 37, 35, 35),
              title: const Text(
                'Student',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(''),
              children: <Widget>[
                if (_isExpanded)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: expansion(context, student),
                  )
                else
                  expansion(context, student),
              ],
            ),
          ),
        ),

        ///Student

        const SizedBox(
          height: 20,
        ),
        Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xff7b4397),
                  Color(0xffdc2430),
                ],
              ),
            ),
            // height: screenHeight * 0.20, // 20% of the screen height
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ExpansionTile(
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isExpanded1 = expanded;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: const BorderSide(color: Colors.transparent)),
                textColor: Colors.black,
                title: const Text(
                  'Admin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(''),
                children: <Widget>[
                  if (_isExpanded1)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: expansion(context, admin),
                    )
                  else
                    expansion(context, admin),
                ],
              ),
            )),

        ///admin
      ],
    );
  }

  Widget expansion(BuildContext context, List<UserModel> user) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: user.length ?? 0,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const DeliveryDetailsStaff(),
              //         settings: RouteSettings(
              //           arguments: {
              //             "month": dataCategory[index].get("month"),
              //             "date": dataCategory[index].get("date"),
              //             "designationPIC": dataCategory[index].get("designationPIC"),
              //             "location": dataCategory[index].get("location"),
              //             "tagNo": dataCategory[index].get("tagNo"),
              //             "equipmentName": dataCategory[index].get("equipmentName"),
              //             "serialNo": dataCategory[index].get("serialNo"),
              //             "model": dataCategory[index].get("model"),
              //             "transportationMode": dataCategory[index].get("transportationMode"),
              //             "transportationFirstDescription": dataCategory[index].get("transportationFirstDescription"),
              //             "physicalCondition": dataCategory[index].get("physicalCondition"),
              //             "statusEquipment": dataCategory[index].get("statusEquipment"),
              //             "referenceNo": dataCategory[index].get("referenceNo"),
              //             "acknowledgmentStatus": dataCategory[index].get("acknowledgmentStatus"),
              //             "acknowledgmentReceipt": dataCategory[index].get("acknowledgmentReceipt"),
              //             "acknowledgmentReceiptName":dataCategory[index].get("acknowledgmentReceiptName"),
              //             "acknowledgmentReceiptDate":dataCategory[index].get("acknowledgmentReceiptDate"),
              //             "userEmail": dataCategory[index].get("userEmail"),
              //           },
              //         )));
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    user[index].name.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    user[index].userID.toString(),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [iconUser(context, user[index])],
                                ),
                              ],
                            ) //icon
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget iconUser(BuildContext context, UserModel user) {
    switch (user.isAdmin) {
      case false:

      ///user
        {
          return IconButton(
            icon: const Icon(
              Icons.group_add,
            ),
            tooltip: "add user as admin",
            onPressed: () async {
              _showDialogStudent(context, user);
            },
          );
        }
      default:

      ///admin
        return IconButton(
          icon: const Icon(
            Icons.delete,
          ),
          tooltip: "remove user from admin",
          onPressed: () async {
            _showDialogAdmin(context, user);
          },
        );
    }
  }

  _showDialogStudent(BuildContext context,UserModel userModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Expanded(
              child: AlertDialog(
                title: const Text('Add User'),
                content: const Text('Do you  want to Add user as admin?'),
                actions: [
                  TextButton(
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                    child: const Text('NO', style: TextStyle(color: Colors.black),),
                  ),
                  TextButton(
                    onPressed: () {
                      UserModel userModelInitialize = UserModel(
                          userID: userModel.userID,
                          name: userModel.name,
                          email: userModel.email,
                          telNumber: userModel.telNumber,
                          isAdmin: true
                      );
                      adminUsimBloc.add(UpdateAdmin(userModelInitialize));

                      refresh();
                      Navigator.of(context).pop();
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
  _showDialogAdmin(BuildContext context,UserModel userModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Expanded(
              child: AlertDialog(
                title: const Text('Remove User'),
                content: const Text('Do you  want to remove user as admin?'),
                actions: [
                  TextButton(
                    onPressed: () {

                      Navigator.of(context).pop();
                    },
                    child: const Text('NO', style: TextStyle(color: Colors.black),),
                  ),
                  TextButton(
                    onPressed: () {
                      UserModel userModelInitialize = UserModel(
                        userID: userModel.userID,
                        name: userModel.name,
                        email: userModel.email,
                        telNumber: userModel.telNumber,
                        isAdmin: false
                      );
                      adminUsimBloc.add(UpdateAdmin(userModelInitialize));

                      refresh();
                      Navigator.of(context).pop();
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



