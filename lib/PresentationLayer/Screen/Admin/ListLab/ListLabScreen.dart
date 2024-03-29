import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:usim_attendance_app/PresentationLayer/Screen/Admin/ListLab/LabAddScreen.dart';
import 'package:usim_attendance_app/PresentationLayer/Screen/Admin/ListLab/lab_update_screen.dart';
import '../../../../Bloc/LabBloc/lab_bloc.dart';

class ListLabScreen extends StatefulWidget {
  const ListLabScreen({Key? key}) : super(key: key);

  @override
  State<ListLabScreen> createState() => _ListLabScreenState();
}

class _ListLabScreenState extends State<ListLabScreen> {
  final LabBloc labBloc = LabBloc();
  String value = '';

  @override
  void initState() {
    labBloc.add(GetListLab());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Index Labs'),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.white,
          foregroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          elevation: 0,
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LabAddScreen()),
                    ).then((value) =>
                        setState(() {
                          // initState();
                          labBloc.add(GetListLab());
                        })
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) {
                  return labBloc;
                },
              ),

            ],
            child:
                BlocBuilder<LabBloc, LabState>(builder: (context, state) {
              if (state is LabLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ListLabLoad) {

                return ListView.builder(
                    itemCount: state.listLabModel.isEmpty
                            ? 0
                            : state.listLabModel.length,
                    itemBuilder: (context, index) {


                      return GestureDetector(
                          onTap: () {},
                          child:  Slidable(
                            /// The end action pane is the one at the right or the bottom side.
                            endActionPane: ActionPane(
                              motion: const StretchMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (BuildContext context) async {

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const LabUpdateScreen(),
                                        settings: RouteSettings(
                                      arguments: {
                                      "labCode":  state
                                          .listLabModel[
                                      index]
                                          .labCode!,
                                      "name":state
                                          .listLabModel[
                                      index]
                                          .name,
                                      "labDetails":state
                                          .listLabModel[
                                      index]
                                          .labDetails,
                                      },
                                      )

                                      ),
                                    ).then((value) =>
                                        setState(() {
                                          // initState();
                                          labBloc.add(GetListLab());
                                        })
                                    );

                                  },
                                  backgroundColor: const Color(0xFF0392CF),
                                  foregroundColor: Colors.white,
                                  icon: Icons.update,
                                  label: 'Update  Laboratory',
                                ),
                                SlidableAction(
                                  onPressed: (BuildContext context) async {

                                    // showDialog(
                                    //   context: context,
                                    //   builder: (BuildContext
                                    //       context) {
                                    //     return AlertDialog(
                                    //       title: const Text(
                                    //           "Delete details"),
                                    //       content: const Text(
                                    //           "Do you want to delete this details?"),
                                    //       actions: [
                                    //         TextButton(
                                    //           child: const Text(
                                    //               "Cancel"),
                                    //           onPressed: () {
                                    //             Navigator.of(
                                    //                     context)
                                    //                 .pop();
                                    //           },
                                    //         ),
                                    //         TextButton(
                                    //           child: const Text(
                                    //               "Delete"),
                                    //           onPressed: () {
                                    //             // Perform the delete operation here
                                    //             Navigator.of(
                                    //                 context)
                                    //                 .pop();
                                    //
                                    //
                                    //
                                    //           },
                                    //         ),
                                    //       ],
                                    //     );
                                    //   },
                                    // );
                                    (context)
                                        .read<LabBloc>()
                                        .add(RemoveLab(
                                        state
                                            .listLabModel[
                                        index]
                                            .labCode!));

                                  },
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete Laboratory',
                                ),

                              ],
                            ),
                            child: Card(
                              color: Theme.of(context).brightness ==
                                  Brightness.dark
                                  ? const Color(0xff1F1F1F)
                                  : const Color(0xffF6F6F6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Text(
                                              state.listLabModel[index].name
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8,top: 8),
                                            child: Text(
                                              state.listLabModel[index]
                                                  .labCode
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                  FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ));
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
        ),
      ),
    );
  }
}
