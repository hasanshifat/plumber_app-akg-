import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plumber_app/components/color.dart';
import 'package:http/http.dart' as http;
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
    userDetailsFunction();
    getProPic();

    setState(() {
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
    final response = await http
        .post(
          url,
          encoding: Encoding.getByName("utf-8"),
          body: {
            "user_id": '1101' // userDetails.userId //'1101'
          },
        )
        .timeout(Duration(seconds: 25))
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
    } else {}
  }

  Future uploadPic() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    // final DialaogsFucntion dialaogsFucntion =
    //     Provider.of<DialaogsFucntion>(context, listen: false);
    var url = Uri.parse('http://49.0.41.34/AKG/PLUMBER/image_upload.php');
    final response = await http
        .post(
          url,
          encoding: Encoding.getByName("utf-8"),
          body: {
            "user_id": '1101', //userDetails.userId //'1101'
            "image": base64image
          },
        )
        .timeout(Duration(seconds: 25))
        .catchError((error) {
          print(error);
        });
    result = json.decode(response.body);
    if (result != null) {
      setState(() {
        profilepic =
            'http://49.0.41.34/AKG/PLUMBER/image_show.php?user_id=${userDetails.userId}';
      });
      print('ff $result');
      print('updated');
    } else
      print('not updated');
  }

  Future getProPic() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    setState(() {
      profilepic =
          'http://49.0.41.34/AKG/PLUMBER/image_show.php?user_id=${userDetails.userId}';
    });
  }

  Future update() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    // final DialaogsFucntion dialaogsFucntion =
    //     Provider.of<DialaogsFucntion>(context, listen: false);
    var url = Uri.parse('http://49.0.41.34/AKG/PLUMBER/registration.php');
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
      setState(() {
        isloading = true;
      });
      userDetailsFunction();
    }
    // if (result['success'] == 1) {
    //  // print(userDetails.userId);

    //   // Navigator.pop(context);
    //   var result = await Connectivity().checkConnectivity();
    //   if (result == ConnectivityResult.none) {
    //     print('no net');
    //     // dialaogsFucntion.noInternet(context);
    //   } else {
    //     // Navigator.push(context, MaterialPageRoute(builder: (_) => Dashboard()));
    //   }

    //   print('ok');
    // }
  }

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
    final selectedImage = await ImagePicker.pickImage(
        source: source,
        imageQuality: 20,
        preferredCameraDevice: CameraDevice.front);
    print(selectedImage);
    if (selectedImage != null) {
      setState(() {
        imageFile = File(selectedImage.path);

        base64image = base64Encode(imageFile.readAsBytesSync());
        uploadPic();
        Navigator.pop(context);
      });
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

  bottomsheetFunction() {
    Size size = MediaQuery.of(context).size;
    final DialaogsFucntion dialaogsFucntion =
        Provider.of<DialaogsFucntion>(context, listen: false);
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
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Container(
                height: size.height * 0.8,
                // color: Colors.red,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: size.height * 0.7,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'নাম',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
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
                            Text(
                              'জন্ম তারিখ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                                height: 40,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
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
                                        onPressed: () =>
                                            selectDObDate(context)),
                                  ],
                                )),
                            Text(
                              'বর্তমান ঠিকানা',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
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
                            Text(
                              'স্থায়ী ঠিকানা',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
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
                            Text(
                              'জরুরী মোবাইল নম্বর',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
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
                            Text(
                              'এন আই ডি',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
                              child: CupertinoTextField(
                                controller: nid,
                                keyboardType: TextInputType.name,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                            Text(
                              'শিক্ষাগত যোগ্যতা',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
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
                            Text(
                              'কর্মক্ষেত্র',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
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
                            Text(
                              'অভিজ্ঞতার বছর',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
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
                            Text(
                              'স্ত্রীর নাম',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
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
                            Text(
                              'বিবাহ দিবস',
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                                height: 40,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
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
                                        onPressed: () =>
                                            selectMRRGDate(context)),
                                  ],
                                )),
                            Text(
                              'সন্তানের সংখ্যা',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 40,
                              width: size.width * 0.8,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      child: Container(
                          height: size.height * 0.07,
                          child: InkWell(
                              onTap: () async {
                                var result =
                                    await Connectivity().checkConnectivity();
                                if (result == ConnectivityResult.none) {
                                  print('no net');
                                  dialaogsFucntion.noInternet(context);
                                } else {
                                  update();
                                  Navigator.pop(context);
                                  // if (usernamecontroller.text.isEmpty) {
                                  //   snackbar(context, 'আপনার মোবাইল নাম্বার দিন!');
                                  //   print('no');
                                  // } else if (passwordcontroller.text.isEmpty) {
                                  //   snackbar(context, 'আপনার পাসওয়ার্ড দিন!');
                                  //   print('no');
                                  // } else {
                                  //   dataSubmit();
                                  //   saveData();
                                  // }
                                }
                              },
                              child: Container(
                                height: size.height * 0.05,
                                width: size.width * 0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.green,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'সেভ করুন',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);

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
                            InkWell(
                              onTap: () {
                                documentBottomSheet();
                              },
                              child: Hero(
                                tag: 'proicon',
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 150),
                                  child: Container(
                                    height: size.height * 0.18,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 5),
                                        color: Colors.black87,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: profilepic == null
                                                ? NetworkImage(img)
                                                : NetworkImage(profilepic),
                                            fit: BoxFit.contain)),
                                  ),
                                ),
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
          bottomsheetFunction();
        },
        child: Icon(
          Icons.edit,
          color: Colors.green,
        ),
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
