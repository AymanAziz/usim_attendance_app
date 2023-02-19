import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Bloc/LabBloc/lab_bloc.dart';




class ListLabScreen extends StatefulWidget {
  const ListLabScreen({Key? key}) : super(key: key);

  @override
  State<ListLabScreen> createState() => _ListLabScreenState();
}

class _ListLabScreenState extends State<ListLabScreen> {
  final LabBloc labBloc = LabBloc();
  String value ='';

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
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const AddHospital()));
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

              BlocProvider(create: (context) => labBloc)
            ],
            child: BlocBuilder<LabBloc, LabState>(
                builder: (context, state) {
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
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
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
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child:  Text( state.listLabModel[index].labCode
                                                  .toString()
                                                ,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.normal),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  final formKey = GlobalKey<FormState>();
                                                  String? name;
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                        ),
                                                        content: SingleChildScrollView(
                                                          child: Form(
                                                            key: formKey,
                                                            child: Column(
                                                              children: <Widget>[
                                                                TextFormField(
                                                                  decoration: const InputDecoration(labelText: 'Enter your name'),
                                                                  onSaved: (value) => name = value,
                                                                  validator: (value) {
                                                                    if (value!.isEmpty) {
                                                                      return 'Please enter your name';
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              if (formKey.currentState!.validate()) {
                                                                formKey.currentState!.save();
                                                                print(name); // Use this data
                                                              }
                                                            },
                                                            child: const Text('Submit'),
                                                          ),
                                                        ],
                                                      );


                                                    },
                                                  );
                                                },
                                              ),

                                              IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {
                                                  // setState(() {   (context)
                                                  //     .read<HospitalReminderBloc>()
                                                  //     .add(GetDeleteHospitalReminder(
                                                  //     state
                                                  //         .reminderHospitalSQL[
                                                  //     index]
                                                  //         .id!)); });

                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )//icon
                                    ],
                                  ),
                                ),
                              ));
                        });

                  }  else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
      ),
    );
  }
}

