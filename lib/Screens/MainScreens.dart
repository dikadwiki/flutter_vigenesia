import 'dart:convert';
import 'package:vigenesia/Models/Motivasi_Model.dart';
import 'package:vigenesia/Screens/EditPage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'Login.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:another_flushbar/flushbar.dart';

class MainScreens extends StatefulWidget {
  final String? idUser;
  final String? nama;
  const MainScreens({
    Key? key,
    this.nama,
    this.idUser,
  }) : super(key: key);

  @override
  _MainScreensState createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  String baseurl = url;
  var dio = Dio();
  TextEditingController titleController = TextEditingController();
  TextEditingController isiController = TextEditingController();

  // Fungsi untuk mengirimkan motivasi
  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {
      "isi_motivasi": isi,
      "iduser": widget.idUser,
    };
    try {
      Response response = await dio.post("$baseurl/api/dev/POSTmotivasi/",
          data: body,
          options: Options(contentType: Headers.formUrlEncodedContentType));
      return response;
    } catch (e) {
      print("Error: $e");
    }
  }

  // Fungsi untuk mendapatkan data motivasi berdasarkan user
  Future<List<MotivasiModel>> getData() async {
    var response =
        await dio.get('$baseurl/api/Get_motivasi?iduser=${widget.idUser}');
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      return getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Fungsi untuk mendapatkan semua data motivasi
  Future<List<MotivasiModel>> getData2() async {
    var response = await dio.get('$baseurl/api/Get_motivasi');
    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      return getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Fungsi untuk menghapus motivasi
  Future<void> deletePost(String id) async {
    dynamic data = {
      "id": id,
    };
    try {
      var response = await dio.delete(
        '$baseurl/api/dev/DELETEmotivasi',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-type": "application/json"},
        ),
      );

      print("Response data: ${response.data}");

      if (response.data != null) {
        var resbody = jsonDecode(response.data);
        Flushbar(
          message: "Motivasi berhasil dihapus.",
          duration: Duration(seconds: 2),
          backgroundColor: Colors.greenAccent,
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
        _getData();
      }
    } catch (e) {
      print("Error saat menghapus motivasi: $e");
    }
  }

  // Fungsi untuk me-refresh data motivasi
  Future<void> _getData() async {
    setState(() {
      getData();
    });
  }

  String? trigger;

  @override
  void initState() {
    super.initState();
    getData();
    getData2();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Light background color for modern feel
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello, ${widget.nama}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple.shade600,
                      ),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.logout, color: Colors.deepPurple.shade600),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Login()));
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Input Text for Motivasi
                FormBuilderTextField(
                  controller: isiController,
                  name: "isi_motivasi",
                  maxLines: 3, // To allow multi-line input
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Tulis Motivasi Kamu...",
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
                SizedBox(height: 20),
                // Submit Button (Changed to Black)
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors
                          .deepPurple.shade400, // Black color for Submit button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      await sendMotivasi(isiController.text).then((value) => {
                            if (value != null)
                              {
                                Flushbar(
                                  message: "Successfully Submitted",
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.greenAccent,
                                  flushbarPosition: FlushbarPosition.TOP,
                                ).show(context)
                              }
                          });
                      _getData();
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white), // Text color white for contrast
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Refresh Button
                Center(
                  child: IconButton(
                    icon: Icon(Icons.refresh,
                        size: 30, color: Colors.deepPurple.shade600),
                    onPressed: () {
                      _getData();
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Filter Motivasi By All or By User
                FormBuilderRadioGroup<String>(
                  onChanged: (value) {
                    setState(() {
                      trigger = value;
                    });
                  },
                  name: "motivationFilter",
                  decoration: InputDecoration(
                    border: InputBorder.none, // This removes the border
                  ),
                  options: ["Semua Motivasi", "User Motivasi"]
                      .map((e) => FormBuilderFieldOption(
                          value: e,
                          child: Text(e, style: TextStyle(fontSize: 16))))
                      .toList(),
                ),
                // Display Motivasi By All or User
                trigger == "Semua Motivasi"
                    ? FutureBuilder<List<MotivasiModel>>(
                        future: getData2(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<MotivasiModel>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No Motivations Found'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var item = snapshot.data![index];
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                      )
                                    ],
                                  ),
                                  child: Text(item.isiMotivasi.toString(),
                                      style: TextStyle(fontSize: 16)),
                                );
                              },
                            );
                          }
                        })
                    : trigger == "User Motivasi"
                        ? FutureBuilder<List<MotivasiModel>>(
                            future: getData(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<MotivasiModel>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('No Motivations Found'));
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    var item = snapshot.data![index];
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                                item.isiMotivasi.toString(),
                                                style: TextStyle(fontSize: 16)),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          EditPage(
                                                              id: item.id,
                                                              isi_motivasi: item
                                                                  .isiMotivasi),
                                                    ),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  deletePost(
                                                      item.id.toString());
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            })
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
