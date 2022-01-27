import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plumber_app/components/color.dart';
import 'package:http/http.dart' as http;
import 'package:plumber_app/components/custom_functions.dart';
import 'package:plumber_app/provider/dialog/dialogs.dart';
import 'package:plumber_app/provider/dialog/user_details.dart';
import 'package:plumber_app/screens/dashboard_menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    sharedpref();

    super.initState();
  }

  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool val1 = false;
  bool passVissible = true;
  bool isLoading = false;
  String uname;
  var porpic;

  Future dataSubmit() async {
    CustomFunctions.waitDialog(context);
    print('un :$uname');
    //  onLoading();
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final DialaogsFucntion dialaogsFucntion =
        Provider.of<DialaogsFucntion>(context, listen: false);

    var url = Uri.parse('http://49.0.41.34/AKG/PLUMBER/login.php');
    var useerData;

    try {
      final response = await http
          .post(
            url,
            // encoding: Encoding.getByName("utf-8"),
            body: {
              "username": uname == '' ? usernamecontroller.text : '$uname',
              "password": passwordcontroller.text
            },
          )
          .timeout(Duration(seconds: 60))
          .catchError((error) {
            print(error);
          });
      useerData = json.decode(response.body);
      print(response);

      if (useerData['success'] == 1) {
        userDetails.dataUserID(useerData['user_id']);
        userDetails.dataUserName(useerData['Person name']);
        userDetails.dataPhoneNumber(useerData['user_id']);
        userDetails.dataAuthCode(useerData['auth code']);
        // print(userDetails.userId);

        Navigator.pop(context);
        var result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.none) {
          print('no net');
          dialaogsFucntion.noInternet(context);
        } else {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => Dashboard()));
        }

        print('ok');
      } else if (useerData['success'] == 0) {
        Navigator.pop(context);
        dialaogsFucntion.msgDialog(context, useerData['msg']);

        //Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
      }
    } catch (e) {
      //dialaogsFucntion.errorDialog(context);
      CustomFunctions.snackbar(
          context, 'কিছু ভুল হয়েছে দয়া করে আবার চেষ্টা করুন!');

      print(e);
    }
  }

  Future getProPic() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    // final DialaogsFucntion dialaogsFucntion =
    //     Provider.of<DialaogsFucntion>(context, listen: false);image_show
    //
    try {
      var url = Uri.parse(
          'http://49.0.41.34/AKG/PLUMBER/image_show.php?user_id=${userDetails.userId}');
      final response = await http
          .get(url)
          .timeout(Duration(seconds: 60))
          .catchError((error) {
        print(error);
      });
      setState(() {
        porpic = json.decode(response.body);
        userDetails.dataImgLink(porpic);
        print(porpic);
      });
    } catch (e) {
      //dialaogsFucntion.errorDialog(context);
      CustomFunctions.snackbar(
          context, 'কিছু ভুল হয়েছে দয়া করে আবার চেষ্টা করুন!');

      print(e);
    }
  }

  onLoading() {
    //Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(child: Text('Please wait')),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            ));
      },
    );
  }

  Future sharedpref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String data = sharedPreferences.getString("uname") ?? '';
    // String datapass = sharedPreferences.getString("upass") ?? '';
    // bool rem = sharedPreferences.getBool("rem") ?? false;
    // this.val1 = rem;
    this.uname = data;
    //this.upass = datapass;
    print('username: $uname');
    // print('pass :$upass');
    // print('val:$val1');

    if (uname != '') {
      setState(() {
        usernamecontroller.value = TextEditingValue(text: uname);
        // passwordcontroller.value = TextEditingValue(text: upass);
        // val1 = true;
      });
    } else {
      setState(() {
        //val1 = false;
      });
    }
  }

  Future saveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      // val1 = val1;
      uname = usernamecontroller.text;
      // upass = passwordcontroller.text;
      sharedPreferences.setString('uname', this.uname);
      // sharedPreferences.setString('upass', this.upass);
      // sharedPreferences.setBool('rem', this.val1);
      print(uname);
    });
  }

  Future snackbar(BuildContext context, String a) async {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      behavior: SnackBarBehavior.floating,
      content: Text(
        a,
        style: TextStyle(color: stella_red),
      ),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DialaogsFucntion dialaogsFucntion =
        Provider.of<DialaogsFucntion>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                width: double.infinity,
                height: size.height * 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      // SvgPicture.asset(
                      //   "images/stellalogo_svg.svg",
                      //   height: size.height * 0.1,
                      // ),
                      // SvgPicture.asset(
                      //   "images/stellalogo_svg.svg",
                      //   height: size.height * 0.2,
                      // ),

                      Container(
                        width: size.height * 0.25,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/stella_logo_img.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Mytext(
                      //                 text: 'মোবাইল নাম্বার',
                      //                 fontsize: 18,
                      //                 fontWeight: FontWeight.w500,
                      //               ),
                      uname == ''
                          ? SizedBox()
                          : SizedBox(
                              height: size.height * 0.05,
                            ),
                      uname != ''
                          ? SizedBox()
                          : SizedBox(
                              height: 40,
                              width: size.width * 0.8,
                              child: CupertinoTextField(
                                controller: usernamecontroller,
                                prefix: Icon(
                                  Icons.phone_android,
                                  color: stella_red,
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                      uname == ''
                          ? SizedBox()
                          : Container(
                              height: 40,
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  border: Border.all(color: Colors.black87),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.phone_android,
                                          color: stella_red,
                                        ),
                                        Text('$uname'),
                                      ],
                                    ),
                                  ))),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      SizedBox(
                        height: 40,
                        width: size.width * 0.8,
                        child: CupertinoTextField(
                          controller: passwordcontroller,
                          onChanged: (val) {
                            if (passwordcontroller.text.length >= 4) {
                              setState(() {
                                val1 = true;
                              });
                            } else
                              setState(() {
                                val1 = false;
                              });
                          },
                          prefix: Icon(
                            Icons.lock,
                            color: stella_red,
                          ),
                          obscureText: passVissible,
                          suffix: IconButton(
                            icon: passVissible
                                ? Icon(
                                    Icons.visibility_off,
                                  )
                                : Icon(
                                    Icons.visibility,
                                  ),
                            onPressed: () {
                              setState(() {
                                passVissible = !passVissible;
                              });
                            },
                            color: Colors.black,
                            iconSize: 18,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black87),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),

                      SizedBox(
                        height: size.height * 0.05,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            // bottom: 0.0,
            // left: 0.0,
            // right: 0.0,
            child: SizedBox(
                height: size.height * 0.07,
                child: InkWell(
                    onTap: val1 == false
                        ? null
                        : () async {
                            var result =
                                await Connectivity().checkConnectivity();
                            if (result == ConnectivityResult.none) {
                              print('no net');
                              dialaogsFucntion.noInternet(context);
                            } else {
                              if (usernamecontroller.text.isEmpty) {
                                snackbar(context, 'আপনার মোবাইল নাম্বার দিন!');
                                print('no');
                              } else if (passwordcontroller.text.isEmpty) {
                                snackbar(context, 'আপনার পাসওয়ার্ড দিন!');
                                print('no');
                              } else {
                                dataSubmit();
                              }
                            }
                          },
                    child: Container(
                      color: val1 == false
                          ? stella_red.withOpacity(0.2)
                          : stella_red,
                      height: size.height * 0.05,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'লগইন করুন',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ))),
          ),
        ],
      ),
    );
  }
}
