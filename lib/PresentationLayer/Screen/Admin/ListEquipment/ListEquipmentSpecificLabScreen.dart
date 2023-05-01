import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../../Bloc/EquipmentBloc/equipment_bloc.dart';
import '../../../../DataLayer/Model/Firestore/EquipmentLabModel/ListEquipmentAdminModel.dart';





/// this state will display in list
class ListEquipmentSpecificLabScreen extends StatefulWidget {
  const ListEquipmentSpecificLabScreen({Key? key}) : super(key: key);

  @override
  State<ListEquipmentSpecificLabScreen> createState() => _ListEquipmentSpecificLabScreenState();
}

class _ListEquipmentSpecificLabScreenState extends State<ListEquipmentSpecificLabScreen> {
  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)?.settings.arguments as Map;
    String labId = todo['labCode'];
    final EquipmentBloc equipmentBloc = EquipmentBloc();

    //80% of screen width
    double cWidth = MediaQuery.of(context).size.width * 0.80;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          floatingActionButton: SizedBox(
            height: 50,
            child: Material(
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromARGB(255, 64, 224, 208),
                      Colors.blue,
                    ],
                  ),
                ),
                child: InkWell(
                  onTap: () {},
                  splashColor: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  highlightColor: Colors.transparent,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add Equipment',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          appBar: null,
          body: Container(
            margin: const EdgeInsets.all(8),
            child: BlocProvider(
              create: (context) {
                equipmentBloc.add(GetListEquipment(labId));
                return equipmentBloc;
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: BlocBuilder<EquipmentBloc, EquipmentState>(
                    builder: (context, state) {
                      if (state is EquipmentInitial) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is EquipmentLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ListEquipmentLoad) {
                        return listEquipmentSpecificLab(state.listEquipmentModel,labId);
                      } else if (state is EquipmentError) {
                        EquipmentListModel list = EquipmentListModel(equipment: []);

                        return listEquipmentSpecificLab(list,labId);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ),
          )),
    );
  }
  /// list Equipment Specific Lab

  Widget listEquipmentSpecificLab(EquipmentListModel list,labId) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${list.equipment.length} Equipment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: list.equipment.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    /// The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (BuildContext context) {
                            context.read<EquipmentBloc>().add(
                              RemoveEquipment(labId ,list.equipment[index]),
                            );
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete_forever,
                          label: 'Remove',
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    list.equipment[index],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}

///// this is for button add new medicine and save
// class CheckValueMedicine extends StatefulWidget {
//   final int id;
//   const CheckValueMedicine({Key? key, required this.id}) : super(key: key);
//
//   @override
//   State<CheckValueMedicine> createState() => _CheckValueMedicineState();
// }
//
// class _CheckValueMedicineState extends State<CheckValueMedicine> {
//
//   final CheckListMedicineBloc checkListMedicineBloc = CheckListMedicineBloc();
//   final ReminderBloc reminderBloc = ReminderBloc();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>checkListMedicineBloc,
//       child: Padding(
//           padding: const EdgeInsets.all(10),
//           child: BlocListener<CheckListMedicineBloc, CheckListMedicineState>(
//             child:  SizedBox(
//               height: 60,
//               child:  Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: InkWell(
//                       onTap: () async {
//                         await Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const AddNewReminderScreen(),
//                                 settings: RouteSettings(
//                                   arguments: {
//                                     "id": widget.id.toString(),
//                                   },
//                                 ))).then((_) => setState(() {
//                           reminderBloc.add(GetListSpecificReminder(widget.id));
//                         }));
//                       },
//                       splashColor: Colors.grey.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(16),
//                       highlightColor: Colors.transparent,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(
//                             Icons.add,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             'Add Medicine',
//                             style: TextStyle(
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: SizedBox(
//                       height: 50,
//                       child: Material(
//                         elevation: 8,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(25)),
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             borderRadius:
//                             BorderRadius.all(Radius.circular(25)),
//                             gradient: LinearGradient(
//                               begin: Alignment.topRight,
//                               end: Alignment.bottomLeft,
//                               colors: [
//                                 Color.fromARGB(255, 64, 224, 208),
//                                 Colors.blue,
//                               ],
//                             ),
//                           ),
//                           child: InkWell(
//                             onTap: () {
//                               checkListMedicineBloc.add(CheckListMedicineForeignKey(widget.id));
//                             },
//                             splashColor: Colors.grey.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(16),
//                             highlightColor: Colors.transparent,
//                             child: const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.save,
//                                   color: Colors.white,
//                                 ),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   'Save',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//
//                   ),
//
//                 ],
//               ),
//             ),
//             listener: (context, state) {
//               if(state is CheckStateLoad)
//               {
//                 if (state.checkValue == false) {
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                         builder: (BuildContext context) =>
//                         const Navbar(),
//                       ),
//                           (Route<dynamic> route) => false);
//                 }
//                 else
//                 {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(const SnackBar(content: Text("medicine is empty. please add medicine"), backgroundColor: Colors.red));
//
//                 }
//
//               }
//             },
//           )
//       ),
//     );
//   }
// }
