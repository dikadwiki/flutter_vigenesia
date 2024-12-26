import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:vigenesia/Constant/const.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String baseurl = url;

  Future postRegister(
      String nama, String profesi, String email, String password) async {
    var dio = Dio();
    dynamic data = {
      "nama": nama,
      "profesi": profesi,
      "email": email,
      "password": password
    };

    try {
      Response response = await dio.post(
        "$baseurl/api/registrasi/",
        data: data,
        options: Options(headers: {'Content-type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deepPurple = Colors.deepPurple.shade200;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Text(
                    "Create an Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Join us and explore the app!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildInputField(
                    "Nama",
                    nameController,
                    deepPurple,
                    TextInputType.text,
                  ),
                  SizedBox(height: 20),
                  _buildInputField(
                    "Profesi",
                    profesiController,
                    deepPurple,
                    TextInputType.text,
                  ),
                  SizedBox(height: 20),
                  _buildInputField(
                    "Email",
                    emailController,
                    deepPurple,
                    TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  _buildInputField(
                    "Password",
                    passwordController,
                    deepPurple,
                    TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepPurple,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await postRegister(
                          nameController.text,
                          profesiController.text,
                          emailController.text,
                          passwordController.text,
                        ).then((value) {
                          if (value != null) {
                            Navigator.pop(context);
                            Flushbar(
                              message: "Berhasil Registrasi",
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.greenAccent,
                              flushbarPosition: FlushbarPosition.TOP,
                            ).show(context);
                          } else {
                            Flushbar(
                              message: "Check Your Field Before Register",
                              duration: Duration(seconds: 5),
                              backgroundColor: Colors.redAccent,
                              flushbarPosition: FlushbarPosition.TOP,
                            ).show(context);
                          }
                        });
                      },
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Already have an account? Sign in",
                      style: TextStyle(color: deepPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    Color color,
    TextInputType keyboardType, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
