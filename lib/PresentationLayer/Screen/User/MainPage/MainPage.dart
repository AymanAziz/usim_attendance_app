import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../Bloc/AttendanceBloc/attendance_bloc.dart';
import '../../../../Bloc/Auth/auth_bloc.dart';
import '../../../../Bloc/GetListLabBloc/get_list_lab_bloc.dart';
import '../../../../DataLayer/Model/Sqlite/LabModel/LabModel.dart';
import '../../Authentication/Login.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _scanBarcode = 'Unknown';
  AttendanceBloc attendanceBloc = AttendanceBloc();
  final GetListLabBloc _getListLabBloc = GetListLabBloc();

  @override
  void initState() {
    attendanceBloc.add(GetListAttendanceUser());
    super.initState();
  }

  DateTime datenow = DateTime.now();

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    /// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    /// If the widget was removed from the tree while the asynchronous platform
    /// message was in flight, we want to discard the reply rather than calling
    /// setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    LabModelSQLite labModelSQLite = LabModelSQLite(labCode: _scanBarcode);
    _getListLabBloc.add(RequestListLab(labModelSQLite));
  }

  ///refresh
  Future<void> refresh() {
    return refreshBloc().then((value) => setState(() {}));
  }

  ///function to get list attendance user
  Future<void> refreshBloc() async {
    attendanceBloc.add(GetListAttendanceUser());

    /// You can do part here what you want to refresh
  }

  @override
  Widget build(BuildContext context) {
    Color colorMainTheme = Theme.of(context).primaryColor;
    String date = DateFormat('d').format(datenow);
    String month = DateFormat("MMM").format(datenow);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Home Page',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
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
                BlocProvider<AttendanceBloc>(create: (context) => attendanceBloc),
                BlocProvider<GetListLabBloc>(create: (context) => _getListLabBloc),
              ],
              child: MultiBlocListener(
                  listeners: [
                    BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) async {
                          if (state is UnAuthenticated) {
                            /// Navigate to the sign in screen when the user Signs Out
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                                  (route) => false,
                            );
                          }
                        }),
                    BlocListener<GetListLabBloc, GetListLabState>(
                        listener: (context, state) async {
                          if (state is ListLabLoaded) {
                            ///return true if user  scan a right qr code
                            print("check if true or not for bloc listener");
                            switch (state.value) {
                              case true:
                                // Navigator.of(context, rootNavigator: true)
                                //     .pushReplacement(MaterialPageRoute(
                                //     builder: (context) => const EquipmentTemplate(),settings: RouteSettings(
                                //   arguments: {"title": _scanBarcode},
                                // )));

                                break;
                              default:
                            }
                          }
                        })
                  ],
                  child: BlocBuilder<AttendanceBloc, AttendanceState>(
                      builder: (context, state) {
                        if (state is AttendanceInitial) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is AttendanceLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is AttendanceListLoaded) {
                          return RefreshIndicator(
                              onRefresh: refresh,
                              child: Builder(builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  child: ListView.builder(
                                    itemCount: state.attendanceList.isEmpty
                                        ? 0
                                        : state.attendanceList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                     return const SizedBox(width: 0,height: 0,);
                                    },
                                  ),
                                );
                              }));
                        } else {
                          return Container();
                        }
                      }))),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 33, 150, 243),
            onPressed: () => scanQR(),
            tooltip: 'Scan QR code',
            elevation: 4.0,
            child: const Icon(Icons.qr_code),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ));
  }
}