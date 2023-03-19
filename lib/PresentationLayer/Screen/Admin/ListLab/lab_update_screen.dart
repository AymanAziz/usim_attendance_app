import 'package:flutter/material.dart';

import '../../../../Bloc/LabBloc/lab_bloc.dart';
import '../../../../DataLayer/Model/Firestore/LabModel/LabModel.dart';

class LabUpdateScreen extends StatefulWidget {
  const LabUpdateScreen({Key? key}) : super(key: key);

  @override
  State<LabUpdateScreen> createState() => _LabUpdateScreenState();
}

class _LabUpdateScreenState extends State<LabUpdateScreen> {

  final _formKey = GlobalKey<FormState>();
  final LabBloc labBloc = LabBloc();

  String finalName = "";
  String finalLabDetails ="";

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)?.settings.arguments as Map;
    String labCode = todo['labCode'];
    String name = todo['name'];
    String labDetails = todo['labDetails'];

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
                  "Update Laboratory",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  initialValue: name,
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
                    finalName = value;
                    return null;
                  },
                  onSaved: (value)
                  {
                    finalName = value!;
                  },
                ),///lab name
                const SizedBox(height: 16),

                TextFormField(
                  initialValue: labDetails,
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
                    finalLabDetails = value!;
                    return null;
                  },
                  onSaved: (value)
                  {
                    finalLabDetails = value!;
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

                              _formKey.currentState!.save();

                              LabModel labModel =
                              LabModel(
                                  labCode:labCode,
                                  name:finalName == ""?name:finalName,
                                  labDetails: finalLabDetails== ""?name:finalLabDetails
                              );

                              labBloc.add(UpdateLab(labModel));

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
                          child: const Text("Update Laboratory"),
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
