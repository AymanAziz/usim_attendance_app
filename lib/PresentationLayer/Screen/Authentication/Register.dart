import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Bloc/Auth/auth_bloc.dart';
import '../../../DataLayer/Model/Firestore/UserModel/UserModel.dart';
import '../../../DataLayer/Repository/Firestore/User/UserRepository.dart';
import '../../Widget/CurveWidget.dart';
import '../../Widget/CurveWidgetRegister.dart';
import 'Login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Register();
}

class _Register extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _userID = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  // Initially password is obscure
  bool _obscureText = true;
  bool _obscureConfirmText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _userID.dispose();
    _rePasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // int cHeight = MediaQuery.of(context).size.height * 1;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: null,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // Navigating to the dashboard screen if the user is authenticated
              // Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (context) => const AdminEquipmentForm(),
              //   ),
              // );
            }
            if (state is AuthError) {
              // Displaying the error message if the user is not authenticated
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            if (state is Loading) {
              /// Displaying the loading indicator while the user is signing up
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UnAuthenticated) {
              /// Displaying the sign up form if the user is not authenticated
              return Container(
                height: double.infinity,
                color: Colors.white,
                child: ListView(shrinkWrap: true, children: [
                  Stack(
                    children: const [
                      CurveWidget(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 4, 52, 84)),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          _email(),
                          const SizedBox(
                            height: 15,
                          ),
                          _password(),
                          const SizedBox(
                            height: 15,
                          ),
                          _rePassword(),
                          const SizedBox(
                            height: 15,
                          ),
                          _fullName(),
                          const SizedBox(
                            height: 15,
                          ),
                          _phoneNumber(),
                          const SizedBox(
                            height: 15,
                          ),
                          _idInput(),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  UserRepository userRepository =
                                      UserRepository();
                                  UserModel userModel = UserModel(
                                    name: _fullNameController.text,
                                    email: _emailController.text,
                                    telNumber: _phoneNumberController.text,
                                    userID: _userID.text,
                                  );
                                  userRepository.addUser(
                                      userModel, _emailController.text);
                                  _createAccountWithEmailAndPassword(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  fixedSize: const Size(300, 60),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              child: const Text('Sign Up'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  GestureDetector(
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
                  )
                ]),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _fullName() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(30)
      ],
      controller: _fullNameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your Full Name";
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20 ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        hintText: 'Full Name',
        hintStyle: TextStyle(color: Colors.grey[700]),
      ),
      onSaved: (val) => _fullNameController.text = val!,
    );
  }

  Widget _email() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(30)
      ],
      controller: _emailController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20 ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.grey[700]),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your email';
        }

        return null;
      },
      onSaved: (val) => _emailController.text = val!,
    );
  }

  Widget _phoneNumber() {

    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(30)
      ],
      controller: _phoneNumberController,
      validator: (value) {
        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
        RegExp regExp = RegExp(pattern);
        if (value == null || value.isEmpty) {
          return "Enter your phone number";
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter valid phone number';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20 ),

        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        hintText: 'Phone Number',
        hintStyle: TextStyle(color: Colors.grey[700]),
      ),
      onSaved: (val) => _phoneNumberController.text = val!,
    );
  }

  Widget _idInput() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(30)
      ],
      controller: _userID,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20 ),

        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        hintText: 'Student Id / Staff Id',
        hintStyle: TextStyle(color: Colors.grey[700]),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your password";
        }
        else
          {  return null;}
      },
    );
  }

  Widget _password() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(30)
      ],
      controller: _passwordController,
      keyboardType: TextInputType.visiblePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: _obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20 ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        suffix: InkWell(
          onTap: _toggle,
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
              size: 16),
        ),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.grey[700]),
      ),
      validator: (value) {
        return value != null && value.length < 6
            ? "Enter min. of 6 characters"
            : null;
      },
    );
  }

  Widget _rePassword() {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(30)
      ],
      controller: _rePasswordController,
      keyboardType: TextInputType.visiblePassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: _obscureConfirmText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter your password";
        }
        return _passwordController.text == value
            ? null
            : "The password is not the same";
      },
      decoration: InputDecoration(

        hintText: 'Re-Password',
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20 ),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: Colors.grey[700]),
        suffix: InkWell(
          onTap: _toggle2,
          child: Icon(
              _obscureConfirmText ? Icons.visibility : Icons.visibility_off,
              size: 16),
        ),
      ),
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(
          _emailController.text,
          _passwordController.text,
        ),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
  }
}
