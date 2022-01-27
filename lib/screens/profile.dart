import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plumber_app/components/color.dart';
import 'package:http/http.dart' as http;
import 'package:plumber_app/components/custom_btn.dart';
import 'package:plumber_app/components/custom_btn_round.dart';
import 'package:plumber_app/components/custom_functions.dart';
import 'package:plumber_app/provider/dialog/dialogs.dart';
import 'package:plumber_app/provider/dialog/user_details.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    setState(() {
      userDetailsFunction();
      getProPic();
      isloading = true;
    });
  }

  bool isloading = false;
  var result;
  DateTime dateTimeTo = DateTime.now();
  var dobdate;
  var mrrgdate;
  File imageFile;
  String base64image;
  File tempImage;
  Uint8List bytesImage;
  String imgString;
  String imgg;
  var profilepic;

  List<ProfileDetails> profileList = [];
  final name = TextEditingController();
  final dob = TextEditingController();
  final presentAddress = TextEditingController();
  final permanentAddress = TextEditingController();
  final ergncyMobileNum = TextEditingController();
  final nid = TextEditingController();
  final education = TextEditingController();
  final workarea = TextEditingController();
  final expYear = TextEditingController();
  final spousename = TextEditingController();
  final marriageday = TextEditingController();
  final chilldrens = TextEditingController();

  Future userDetailsFunction() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    print(userDetails.imglink);

    // final DialaogsFucntion dialaogsFucntion =
    //     Provider.of<DialaogsFucntion>(context, listen: false);
    var url = Uri.parse('http://49.0.41.34/AKG/PLUMBER/plumber_details.php');
    try {
      final response = await http
          .post(
            url,
            encoding: Encoding.getByName("utf-8"),
            body: {
              "user_id": userDetails.userId //'1101'
            },
          )
          .timeout(Duration(seconds: 60))
          .catchError((error) {
            print(error);
          });
      var result = json.decode(response.body);
      print(result);
      profileList = [];

      if (result['plumber details'] != null) {
        setState(() {
          List l = result['plumber details'];
          l.forEach((element) {
            profileList.add(ProfileDetails(
                regID: element['REG_ID'],
                uid: element['USER_ID'],
                name: element['NAME'],
                presentAddress: element['PRESENT_ADRESS'],
                permanetAddress: element['PERMANENT_ADRESS'],
                cellNo: element['CELL_NO'],
                emergencyContact: element['EMERGENCY_CONTARACT_NO'],
                nid: element['NID_NO'],
                education: element['EDUCATION'],
                workLocation: element['WORK_LOCATION'],
                yearsOfExp: element['YEARS_OF_EXEPERIENCE'],
                nameOfSpouse: element['NMAE_OF_SPOUSE'],
                marraigeDay: element['MARRIAGE_DAY_F'],
                noOfChild: element['NO_OF_CHILD'],
                dob: element['DOB_F']));
          });
          isloading = false;
        });
      }
    } catch (e) {
      //dialaogsFucntion.errorDialog(context);
      CustomFunctions.snackbar(
          context, 'কিছু ভুল হয়েছে দয়া করে আবার চেষ্টা করুন!');
      Navigator.pop(context);
      print(e);
    }
  }

  Future getProPic() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    try {
      setState(() {
        profilepic =
            'http://49.0.41.34/AKG/PLUMBER/image_show.php?user_id=${userDetails.userId}';
      });
    } catch (e) {
      //dialaogsFucntion.errorDialog(context);
      CustomFunctions.snackbar(
          context, 'কিছু ভুল হয়েছে দয়া করে আবার চেষ্টা করুন!');
      Navigator.pop(context);
      print(e);
    }
  }

  Future selectDObDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTimeTo,
        firstDate: DateTime(1950),
        lastDate: DateTime(3000),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.black87,
                onPrimary: Colors.white,
                surface: stella_red,
                onSurface: Colors.black87,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });
    if (picked != null) {
      setState(() {
        dateTimeTo = picked;
        dobdate = "${dateTimeTo.day}/${dateTimeTo.month}/${dateTimeTo.year}";
        print('dobdate $dobdate');
      });
    }
  }

  Future selectMRRGDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTimeTo,
        firstDate: DateTime(1950),
        lastDate: DateTime(3000),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.black87,
                onPrimary: Colors.white,
                surface: stella_red,
                onSurface: Colors.black87,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });
    if (picked != null) {
      setState(() {
        dateTimeTo = picked;
        mrrgdate = "${dateTimeTo.day}/${dateTimeTo.month}/${dateTimeTo.year}";

        print('mrrgdate $mrrgdate');
      });
    }
  }

  goToSecondScreen() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EdirProfile(
                  profileList: profileList,
                  profilepic: profilepic,
                )));
    print(result);
    userDetailsFunction();
    getProPic();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: isloading == true
              ? result == null
                  ? Center(
                      child: Text('No data'),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    )
              : Container(
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            //color: Colors.yellow,
                            ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              child: Container(
                                height: size.height,
                                width: double.infinity,
                              ),
                              painter: CurvedContainer(),
                            ),
                            Hero(
                              tag: 'proicon',
                              child: Padding(
                                padding: const EdgeInsets.only(top: 150),
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 50,
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                          child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: profileList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Table(
                              //border: TableBorder.all(),
                              columnWidths: {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(0.2),
                                2: FlexColumnWidth(3),
                              },
                              children: [
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: stella_red.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'নাম',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].name,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'জন্ম তারিখ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      ':',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      profileList[index].dob,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.blue.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'বর্তমান ঠিকানা',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].presentAddress,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                                TableRow(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'স্থায়ী ঠিকানা',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      ':',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      profileList[index].permanetAddress,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'মোবাইল নম্বর',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].cellNo,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'জরুরী মোবাইল নম্বর',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].emergencyContact,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'এন আই ডি',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].nid,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'শিক্ষাগত যোগ্যতা',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].education,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'কর্মক্ষেত্র',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].workLocation,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'অভিজ্ঞতার বছর',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].yearsOfExp,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'স্ত্রীর নাম',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].nameOfSpouse,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'বিবাহ দিবস',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].marraigeDay,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                                TableRow(
                                    // decoration: BoxDecoration(
                                    //     color: Colors.grey.withOpacity(0.2)),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'সন্তানের সংখ্যা',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          profileList[index].noOfChild,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                          );
                        },
                      )),
                      // SizedBox(
                      //   width: size.width * 0.6,
                      //   child: MaterialButton(
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(5)),
                      //     onPressed: () {},
                      //     color: Colors.green,
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(horizontal: 5),
                      //       child: Text(
                      //         'আপনার টাকা তুলুন',
                      //         style:
                      //             TextStyle(color: Colors.white, fontSize: 18),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          goToSecondScreen();
          //bottomsheetFunction();
        },
        child: Icon(
          Icons.edit,
          color: Colors.green,
        ),
      ),
    );
  }
}

class EdirProfile extends StatefulWidget {
  final List<ProfileDetails> profileList;
  final profilepic;
  const EdirProfile({Key key, this.profileList, this.profilepic})
      : super(key: key);

  @override
  _EdirProfileState createState() => _EdirProfileState();
}

class _EdirProfileState extends State<EdirProfile> {
  @override
  void initState() {
    super.initState();
    setState(() {
      isloading = true;
      profilepic = widget.profilepic;
      profileList = widget.profileList;
      profileList.forEach((element) {
        setState(() {
          name.text = element.name;
          dobdate = element.dob;
          presentAddress.text = element.presentAddress;
          permanentAddress.text = element.permanetAddress;
          ergncyMobileNum.text = element.emergencyContact;
          nid.text = element.nid;
          education.text = element.education;
          workarea.text = element.workLocation;
          expYear.text = element.yearsOfExp;
          spousename.text = element.nameOfSpouse;
          mrrgdate = element.marraigeDay;
          chilldrens.text = element.noOfChild;
        });
      });
    });
  }

  bool isloading = false;
  List<ProfileDetails> profileList = [];
  var result;
  DateTime dateTimeTo = DateTime.now();
  var dobdate;
  var mrrgdate;
  File imageFile;
  String base64image;
  File tempImage;
  Uint8List bytesImage;
  String imgString;
  String imgg;
  var profilepic;
  final name = TextEditingController();
  final dob = TextEditingController();
  final presentAddress = TextEditingController();
  final permanentAddress = TextEditingController();
  final ergncyMobileNum = TextEditingController();
  final nid = TextEditingController();
  final education = TextEditingController();
  final workarea = TextEditingController();
  final expYear = TextEditingController();
  final spousename = TextEditingController();
  final marriageday = TextEditingController();
  final chilldrens = TextEditingController();

  documentBottomSheet() async {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.grey[300],
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
                  icon: Icon(
                    Icons.photo_camera,
                    color: Colors.black,
                  ),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.photo, color: Colors.black),
                  iconSize: 40,
                ),
              ],
            ),
          );
        });
  }

  Future pickImage(ImageSource source) async {
    final selectedImage = await ImagePicker.platform.getImage(
        source: source,
        imageQuality: 20,
        preferredCameraDevice: CameraDevice.front);

    try {
      if (selectedImage != null) {
        setState(() {
          imageFile = File(selectedImage.path);

          base64image = base64Encode(imageFile.readAsBytesSync());
          Navigator.pop(context);
        });
      }
    } catch (e) {
      //dialaogsFucntion.errorDialog(context);
      CustomFunctions.snackbar(
          context, 'কিছু ভুল হয়েছে দয়া করে আবার চেষ্টা করুন!');

      print(e);
    }
  }

  Future update() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final DialaogsFucntion dialaogsFucntion =
        Provider.of<DialaogsFucntion>(context, listen: false);
    uploadPic();
    dialaogsFucntion.waitDialog(context);

    try {
      final response = await http
          .post(
            Uri.parse('http://49.0.41.34/AKG/PLUMBER/registration.php'),
            encoding: Encoding.getByName("utf-8"),
            body: {
              "user_id": '1101', //userDetails.userId, //'1101',
              "name": name.text,
              "phone_no": '01712132313',
              "DOB": dobdate,
              "emgency_contract_no": ergncyMobileNum.text,
              "nid": nid.text,
              "present_address": presentAddress.text,
              "permanent_address": permanentAddress.text,
              "work_location": workarea.text,
              "years_of_exepeience": expYear.text,
              "name_of_the_spouse": spousename.text,
              "no_of_child": chilldrens.text,
              "marriage_day": mrrgdate,
              "education": education.text,
            },
          )
          .timeout(Duration(seconds: 25))
          .catchError((error) {
            print(error);
          });
      result = json.decode(response.body);
      print('feedback: $result');
      if (result['success'] == 1) {
        Navigator.pop(context);
        //Navigator.pop(context);

        setState(() {
          userDetails.dataUserName(name.text);
          isloading = true;
        });
      }
    } catch (e) {
      //dialaogsFucntion.errorDialog(context);
      CustomFunctions.snackbar(
          context, 'কিছু ভুল হয়েছে দয়া করে আবার চেষ্টা করুন!');

      print(e);
    }
    // var url = Uri.parse('http://49.0.41.34/AKG/PLUMBER/registration.php');
  }

  Future getProPic() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    // final DialaogsFucntion dialaogsFucntion =
    //     Provider.of<DialaogsFucntion>(context, listen: false);image_show
    //
    try {
      setState(() {
        var porpic =
            'http://49.0.41.34/AKG/PLUMBER/image_show.php?user_id=${userDetails.userId}';
        imglink = porpic;
        print(imglink);
      });
    } catch (e) {
      //dialaogsFucntion.errorDialog(context);
      CustomFunctions.snackbar(
          context, 'কিছু ভুল হয়েছে দয়া করে আবার চেষ্টা করুন!');
      print(e);
    }
  }

  Future uploadPic() async {
    final DialaogsFucntion dialaogsFucntion =
        Provider.of<DialaogsFucntion>(context, listen: false);
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    dialaogsFucntion.waitDialog(context);
    var url = Uri.parse('http://49.0.41.34/AKG/PLUMBER/image_upload.php');
    try {
      final response = await http
          .post(
            url,
            encoding: Encoding.getByName("utf-8"),
            body: {
              "user_id": userDetails.userId, //'1101'
              "image": base64image
            },
          )
          .timeout(Duration(seconds: 25))
          .catchError((error) {
            print(error);
          });
      result = json.decode(response.body);

      if (result != null) {
        Navigator.pop(context);
        Future.delayed(Duration.zero, () {
          this.getProPic();
        });
        print('ff $result');
        print('updated');
      } else
        print('not updated');
    } catch (e) {
      //dialaogsFucntion.errorDialog(context);
      CustomFunctions.snackbar(
          context, 'কিছু ভুল হয়েছে দয়া করে আবার চেষ্টা করুন!');

      print(e);
    }
  }

  Future selectDObDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTimeTo,
        firstDate: DateTime(1950),
        lastDate: DateTime(3000),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.black87,
                onPrimary: Colors.white,
                surface: stella_red,
                onSurface: Colors.black87,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });
    if (picked != null) {
      setState(() {
        dateTimeTo = picked;
        dobdate = "${dateTimeTo.day}/${dateTimeTo.month}/${dateTimeTo.year}";
        print('dobdate $dobdate');
      });
    }
  }

  Future selectMRRGDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTimeTo,
        firstDate: DateTime(1950),
        lastDate: DateTime(3000),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.black87,
                onPrimary: Colors.white,
                surface: stella_red,
                onSurface: Colors.black87,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child,
          );
        });
    if (picked != null) {
      setState(() {
        dateTimeTo = picked;
        mrrgdate = "${dateTimeTo.day}/${dateTimeTo.month}/${dateTimeTo.year}";

        print('mrrgdate $mrrgdate');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Container(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 20),
                  //   child: InkWell(
                  //     onTap: () => documentBottomSheet(),
                  //     child: CircleAvatar(
                  //         backgroundColor: Colors.white,
                  //         radius: 50,
                  //         child: const Icon(
                  //           Icons.person,
                  //           size: 50,
                  //         )),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'নাম',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(
                    height: 40,
                    width: size.width * 1,
                    child: CupertinoTextField(
                      controller: name,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  S10,
                  Text(
                    'জন্ম তারিখ',
                    style: TextStyle(fontSize: 18),
                  ),

                  Container(
                      height: 40,
                      width: size.width * 1,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              '$dobdate',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.date_range,
                                color: stella_red,
                              ),
                              onPressed: () => selectDObDate(context)),
                        ],
                      )),
                  S10,
                  Text(
                    'বর্তমান ঠিকানা',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(
                    height: 40,
                    width: size.width * 1,
                    child: CupertinoTextField(
                      controller: presentAddress,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  S10,
                  Text(
                    'স্থায়ী ঠিকানা',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(
                    height: 40,
                    width: size.width * 1,
                    child: CupertinoTextField(
                      controller: permanentAddress,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  S10,
                  Text(
                    'জরুরী মোবাইল নম্বর',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(
                    height: 40,
                    width: size.width * 1,
                    child: CupertinoTextField(
                      controller: ergncyMobileNum,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Text(
                  //   'এন আই ডি',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // SizedBox(
                  //   height: 40,
                  //   width: size.width * 0.8,
                  //   child: CupertinoTextField(
                  //     controller: nid,
                  //     keyboardType: TextInputType.name,
                  //     textAlignVertical: TextAlignVertical.center,
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         border: Border.all(color: Colors.black87),
                  //         borderRadius: BorderRadius.circular(5)),
                  //   ),
                  // ),
                  S10,
                  Text(
                    'শিক্ষাগত যোগ্যতা',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(
                    height: 40,
                    width: size.width * 1,
                    child: CupertinoTextField(
                      controller: education,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  S10,
                  Text(
                    'কর্মক্ষেত্র',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(
                    height: 40,
                    width: size.width * 1,
                    child: CupertinoTextField(
                      controller: workarea,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  S10,
                  Text(
                    'অভিজ্ঞতার বছর',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(
                    height: 40,
                    width: size.width * 1,
                    child: CupertinoTextField(
                      controller: expYear,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  S10,
                  Text(
                    'স্ত্রীর নাম',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(
                    height: 40,
                    width: size.width * 1,
                    child: CupertinoTextField(
                      controller: spousename,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  S10,
                  Text(
                    'বিবাহ দিবস',
                    style: TextStyle(fontSize: 18),
                  ),

                  Container(
                      height: 40,
                      width: size.width * 1,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              '$mrrgdate',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.date_range,
                                color: stella_red,
                              ),
                              onPressed: () => selectMRRGDate(context)),
                        ],
                      )),
                  S10,
                  Text(
                    'সন্তানের সংখ্যা',
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(
                    height: 40,
                    width: size.width * 1,
                    child: CupertinoTextField(
                      controller: chilldrens,
                      keyboardType: TextInputType.name,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  S10,
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CustomBtnRound(
                press: () => Navigator.pop(context),
                text: 'Back',
                color: Colors.blue,
              ),
              CustomBtn(
                press: () => update(),
                text: 'Save',
                color: Colors.transparent,
                textcolor: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileDetails {
  var regID;
  var name;
  var uid;
  var presentAddress;
  var permanetAddress;
  var cellNo;
  var emergencyContact;
  var nid;
  var education;
  var workLocation;
  var yearsOfExp;
  var nameOfSpouse;
  var marraigeDay;
  var noOfChild;
  var dob;
  ProfileDetails(
      {this.regID,
      this.uid,
      this.name,
      this.cellNo,
      this.dob,
      this.education,
      this.emergencyContact,
      this.marraigeDay,
      this.nameOfSpouse,
      this.nid,
      this.noOfChild,
      this.permanetAddress,
      this.presentAddress,
      this.workLocation,
      this.yearsOfExp});
}

class CurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = stella_red;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
