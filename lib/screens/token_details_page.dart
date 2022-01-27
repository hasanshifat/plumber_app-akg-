import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plumber_app/components/color.dart';
import 'package:http/http.dart' as http;
import 'package:plumber_app/components/custom_functions.dart';
import 'package:plumber_app/provider/dialog/user_details.dart';
import 'package:provider/provider.dart';
// import 'package:plumber_app/provider/dialog/dialogs.dart';
// import 'package:plumber_app/provider/dialog/user_details.dart';
// import 'package:provider/provider.dart';

class TokenDetailsPgae extends StatefulWidget {
  @override
  _TokenDetailsPgaeState createState() => _TokenDetailsPgaeState();
}

class _TokenDetailsPgaeState extends State<TokenDetailsPgae> {
  @override
  void initState() {
    super.initState();
    tokenDetails();
  }

  bool isloading = false;
  var currentMonthpoint;
  var previousMonthpoint;
  var previousYears;
  var currentYears;

  Future tokenDetails() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    // final DialaogsFucntion dialaogsFucntion =
    //     Provider.of<DialaogsFucntion>(context, listen: false);

    // var params = {
    //   "user_id": '1101',
    // };

    // Response response;
    // var dio = Dio();
    // response = await dio
    //     .post('http://49.0.41.34/AKG/PLUMBER/plumber_token_details.php',
    //         queryParameters: params,
    //         options: Options(headers: {
    //           HttpHeaders.contentTypeHeader: "application/json",
    //         }))
    //     .timeout(Duration(seconds: 25))
    //     .catchError((error) {
    //   print(error);
    // });

    // var result = json.decode(response.toString());
    // print('feedback:  $result');
    // setState(() {
    //   currentMonthpoint = result['current month total Token point'];
    //   previousMonthpoint = result['previous month total Token point'];
    //   currentYears = result['current years total Token point'];
    //   previousYears = result['previous years total Token point'];
    //   print('$previousYears');
    //   isloading = false;
    // });

    var url =
        Uri.parse('http://49.0.41.34/AKG/PLUMBER/plumber_token_details.php');
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
      // print(result['current month total Token point']);
      setState(() {
        currentMonthpoint = result['current month total Token point'];
        previousMonthpoint = result['previous month total Token point'];
        currentYears = result['current years total Token point'];
        previousYears = result['previous years total Token point'];
        print('$previousYears');
        isloading = false;
      });
    } catch (e) {
      //dialaogsFucntion.errorDialog(context);
      CustomFunctions.snackbar(context, 'কিছু ভুল হয়েছে দয়া করে আবার চেষ্টা করুন!');
      Navigator.pop(context);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final DialaogsFucntion dialaogsFucntion =
    //     Provider.of<DialaogsFucntion>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('সকল টোকেনের হিসাব'),
      //   centerTitle: true,
      //   backgroundColor: stella_red,
      // ),
      body: SafeArea(
        child: Container(
          child: isloading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          border: TableBorder.all(),
                          columnWidths: {
                            0: FlexColumnWidth(4),
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            TableRow(
                                decoration: BoxDecoration(
                                    color: stella_red.withOpacity(0.2)),
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'মাসের/বছরের টোকেন সংখ্যা',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'পয়েন্ট',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  )
                                ]),
                            TableRow(children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'এই মাসের টোকেন পয়েন্ট',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    currentMonthpoint == null
                                        ? '0'
                                        : '$currentMonthpoint',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              )
                            ]),
                            TableRow(
                                decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2)),
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'গত মাসের টোকেন পয়েন্ট',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        previousMonthpoint == null
                                            ? '0'
                                            : '$previousMonthpoint',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  )
                                ]),
                            TableRow(children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    'এই বছরের টোকেন সংখ্যা',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    currentYears == null
                                        ? '0'
                                        : '$currentYears',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              )
                            ]),
                            TableRow(
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2)),
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'গত বছরের টোকেন সংখ্যা',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        previousYears == null
                                            ? '0'
                                            : '$previousYears',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  )
                                ]),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        onPressed: () {},
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            'আপনার টাকা তুলুন',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
