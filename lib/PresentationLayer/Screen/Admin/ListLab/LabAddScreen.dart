import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usim_attendance_app/Bloc/LabBloc/lab_bloc.dart';

import '../../../../DataLayer/Model/Firestore/LabModel/LabModel.dart';

class LabAddScreen extends StatefulWidget {
  const LabAddScreen({Key? key}) : super(key: key);

  @override
  State<LabAddScreen> createState() => _LabAddScreenState();
}

class _LabAddScreenState extends State<LabAddScreen> {
  //form
  final _formKey = GlobalKey<FormState>();
  final LabBloc labBloc = LabBloc();

  String name = "";
  String labCode = "";
  String labDetails ="";
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: null,
          body: Form(
            key: _formKey,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),

              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              shrinkWrap: true,
              children: [
                const SizedBox(height: 60),
                const Text(
                  "Add Laboratory",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Expanded(
                  child: Text(
                    "Please be aware that once you press the Add button, you will be unable to modify your Laboratory Code. "
                        "Therefore, we advise you to review your Laboratory Code carefully before adding it to ensure that it is"
                        " accurate and complete",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  // inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Lab Name',
                    hintStyle: TextStyle(color: Colors.grey[700]),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Lab Name';
                    }
                    name = value;
                    return null;
                  },
                ),///lab name
                const SizedBox(height: 16),
                TextFormField(
                  inputFormatters: [LengthLimitingTextInputFormatter(30)],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Lab Code',
                    hintStyle: TextStyle(color: Colors.grey[700]),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Lab Code';
                    }
                    labCode = value;
                    return null;
                  },
                ),/// lab code
                const SizedBox(height: 16),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Lab Description',
                    hintStyle: TextStyle(color: Colors.grey[700]),
                  ),
                  validator: (value) {
                    // if (value == null || value.isEmpty) {
                    //   return 'Please enter Lab Description';
                    // }
                    labDetails = value!;
                    return null;
                  },
                ),///lab description

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
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
                        child: ElevatedButton(
                          onPressed: () async {




                            if (_formKey.currentState!.validate()) {
                              // final FirebaseAuth auth = FirebaseAuth.instance;
                              // String? uid = auth.currentUser?.uid;

                              _formKey.currentState!.save();

                              LabModel labModel =
                              LabModel(
                                  labCode:labCode,
                                  name:name,
                                  labDetails: labDetails
                              );

                               labBloc.add(AddNewLab(labModel));

                              await Future.delayed(
                                  const Duration(microseconds: 1));
                              if (!mounted) return;
                              Navigator.pop(context, "refresh");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              fixedSize: const Size(300, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          child: const Text("Add Laboratory"),
                        )),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4 - 16,

                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 16,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color.fromARGB(255, 64, 224, 208),
                                  Colors.blue,
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4 - 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}