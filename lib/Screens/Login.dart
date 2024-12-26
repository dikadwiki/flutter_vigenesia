import 'package:vigenesia/Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'MainScreens.dart';
import 'Register.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'package:vigenesia/Models/Login_Model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? nama;
  String? iduser;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<LoginModels?> postLogin(String? email, String? password) async {
    var dio = Dio();
    String baseurl = url;
    Map<String, dynamic> data = {"email": email, "password": password};

    try {
      final response = await dio.post("$baseurl/api/login/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));
      if (response.statusCode == 200) {
        final loginModel = LoginModels.fromJson(response.data);
        return loginModel;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors
                    .deepPurple.shade200), // Deep purple shade 200 background
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title Text
                Text(
                  "VIGENESIA",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Visi Generasi Indonesia",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 50), // Spacing between title and form

                // Login Card Form
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _fbKey,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        margin: EdgeInsets.only(
                          top: 20,
                          left: 50.0,
                          right: 50.0,
                          bottom: 20,
                        ),
                        child: Column(
                          children: [
                            // Login Header Text
                            Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w800,
                                color: Colors.deepPurple
                                    .shade200, // Deep purple shade 200 color
                              ),
                            ),
                            SizedBox(height: 20),

                            // Email Input Field
                            FormBuilderTextField(
                              name: "email",
                              controller: emailController,
                              cursorColor: Colors.deepPurple.shade200,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: BorderSide(
                                    color: Colors.deepPurple.shade200,
                                    width: 0.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: BorderSide(
                                    color: Colors.deepPurple.shade200,
                                    width: 1.0,
                                  ),
                                ),
                                labelText: "Email",
                                labelStyle: TextStyle(
                                    color: Colors.deepPurple.shade400),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Password Input Field
                            FormBuilderTextField(
                              obscureText: true,
                              name: "password",
                              controller: passwordController,
                              cursorColor: Colors.deepPurple.shade400,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: BorderSide(
                                    color: Colors.deepPurple.shade400,
                                    width: 0.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: BorderSide(
                                    color: Colors.deepPurple.shade200,
                                    width: 1.0,
                                  ),
                                ),
                                labelText: "Password",
                                labelStyle: TextStyle(
                                    color: Colors.deepPurple.shade400),
                              ),
                            ),
                            SizedBox(height: 30),

                            // Sign In Button
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors
                                      .deepPurple
                                      .shade200), // Deep purple shade 200 button
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  )),
                                ),
                                onPressed: () async {
                                  await postLogin(emailController.text,
                                          passwordController.text)
                                      .then((value) => {
                                            if (value != null)
                                              {
                                                setState(() {
                                                  nama = value.data.nama;
                                                  iduser = value.data.iduser;
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              MainScreens(
                                                                nama: nama,
                                                                idUser: iduser,
                                                              ))); // Redirect to main screen
                                                })
                                              }
                                            else if (value == null)
                                              {
                                                Flushbar(
                                                  message:
                                                      "Check Your Email / Password",
                                                  duration:
                                                      Duration(seconds: 5),
                                                  backgroundColor: Colors
                                                      .deepPurpleAccent, // Deep purple accent error message
                                                  flushbarPosition:
                                                      FlushbarPosition.TOP,
                                                ).show(context)
                                              }
                                          });
                                },
                                child: Text("Sign In"),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Sign-Up Link
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  TextSpan(
                                    text: 'Sign Up',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Register(),
                                          ),
                                        );
                                      },
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
