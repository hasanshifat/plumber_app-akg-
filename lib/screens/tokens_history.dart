import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plumber_app/components/color.dart';
import 'package:plumber_app/provider/dialog/user_details.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TokenHistory extends StatefulWidget {
  @override
  _TokenHistoryState createState() => _TokenHistoryState();
}

class _TokenHistoryState extends State<TokenHistory> {
  DateTime dateTimeTo = DateTime.now();
  var toDate;
  var fromDate;
  bool isloading = false;
  List<TokenHistoryClass> list = [];

  Future selectToDate(BuildContext context) async {
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
        toDate = "${dateTimeTo.day}/${dateTimeTo.month}/${dateTimeTo.year}";

        print('toDate $toDate');
      });
    }
  }

  Future selectFormDate(BuildContext context) async {
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
        fromDate = "${dateTimeTo.day}/${dateTimeTo.month}/${dateTimeTo.year}";
        print('fromDate $fromDate');
      });
    }
  }

  Future tokenDetails() async {
    list = [];
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    // final DialaogsFucntion dialaogsFucntion =
    //     Provider.of<DialaogsFucntion>(context, listen: false);
    var url = Uri.parse('http://49.0.41.34/AKG/PLUMBER/token_filter.php');
    final response = await http
        .post(
          url,
          encoding: Encoding.getByName("utf-8"),
          body: {
            "from_date": fromDate,
            "to_date": toDate,
            "user_id": '1101'//userDetails.userId, //'1101'
          },
        )
        .timeout(Duration(seconds: 25))
        .catchError((error) {
          print(error);
        });
    var result = json.decode(response.body);
    print(result);
    List r = result['transaction history'];
    // print(result['current month total Token point']);
    if (result != null) {
      setState(() {
        isloading = false;
      });
      r.forEach((element) {
        setState(() {
          list.add(TokenHistoryClass(
            transactionid: element['TRANSACTION_ID'],
            tokenid: element['TOKEN_ID'],
            tokenpoints: element['TOKEN_POINTS'],
            productcategory: element['PRODUCT_CATEGORY'],
            date: element['CREATION_DATE'],
            time: element['TIME'],
          ));
        });
      });
    } else {
      setState(() {
        isloading = false;
      });
    }

    // if (result['success'] == 1) {
    //   //dialaogsFucntion.msgDialog(context, 'ok');
    //   print(result);
    // } else if (result['success'] == 0) {
    //   // dialaogsFucntion.msgDialog(context, result['msg']);
    //   print(result);
    // }
  }

  Future snackbar(BuildContext context) async {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      backgroundColor: Colors.red[600],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      behavior: SnackBarBehavior.floating,
      content: Text(
        'শুরুর/শেষ তারিখ দিন',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'শুরুর তারিখ : ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'শেষ তারিখ :  ',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: size.width * 0.3,
                      child: OutlinedButton(
                        onPressed: () {
                          selectFormDate(context);
                        },
                        child:
                            Text(fromDate == null ? 'তারিখ দিন' : '$fromDate'),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.3,
                      child: OutlinedButton(
                        onPressed: () {
                          selectToDate(context);
                        },
                        child: Text(toDate == null ? 'তারিখ দিন' : '$toDate'),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    if (fromDate == null && toDate == null) {
                      snackbar(context);
                    } else {
                      setState(() {
                        isloading = true;
                      });
                      tokenDetails();
                    }
                  },
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'দেখুন',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              list.isEmpty
                  ? isloading == true
                      ? CircularProgressIndicator()
                      : SizedBox()
                  : Expanded(
                      child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Table(
                          //border: TableBorder.all(),
                          columnWidths: {
                            0: FlexColumnWidth(3),
                            1: FlexColumnWidth(0.5),
                            2: FlexColumnWidth(3),
                          },
                          children: [
                            TableRow(
                                decoration: BoxDecoration(
                                    color: stella_red.withOpacity(0.2)),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'পণ্য তালিকা',
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
                                      '${list[index].productcategory}',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'লেনদেন নাম্বার',
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
                                  '${list[index].transactionid}',
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
                                      'তৈরির তারিখ',
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
                                      '${list[index].date}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  'তৈরির সময়',
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
                                  '${list[index].time}',
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
                                      'টোকেন আইডি',
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
                                      '${list[index].tokenid}',
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
                                      'টোকেন পয়েন্ট',
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
                                      '${list[index].tokenpoints}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                          ],
                        );
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       'পণ্য তালিকা : ${list[index].productcategory}',
                        //       style: TextStyle(color: stella_red, fontSize: 25),
                        //     ),
                        //     Row(
                        //       crossAxisAlignment: CrossAxisAlignment.baseline,
                        //       textBaseline: TextBaseline.alphabetic,
                        //       children: [
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'লেনদেন নাম্বার',
                        //             ),

                        //             // Text(
                        //             //   'লেনদেন নাম্বার \t\t\nতৈরির তারিখ \t\t\nতৈরির সময় \t\t\nটোকেন আইডি\t\t\nটোকেন পয়েন্ট',
                        //             // ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             // Text(
                        //             //   ':\t\t\n:\t\t\n:\t\t\n:\t\t\n: ',
                        //             // ),
                        //             Text(
                        //               ' : ',
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Expanded(
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             verticalDirection: VerticalDirection.down,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               // Text(
                        //               //   '${list[index].transactionid}\t\t\n${list[index].date}\t\t\n${list[index].time}\t\t\n${list[index].tokenid}\t\t\n${list[index].tokenpoints}',
                        //               // ),
                        //               Text(
                        //                 '${list[index].transactionid}',
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       crossAxisAlignment: CrossAxisAlignment.baseline,
                        //       textBaseline: TextBaseline.alphabetic,
                        //       children: [
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'তৈরির তারিখ',
                        //             ),

                        //             // Text(
                        //             //   'লেনদেন নাম্বার \t\t\nতৈরির তারিখ \t\t\nতৈরির সময় \t\t\nটোকেন আইডি\t\t\nটোকেন পয়েন্ট',
                        //             // ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             // Text(
                        //             //   ':\t\t\n:\t\t\n:\t\t\n:\t\t\n: ',
                        //             // ),
                        //             Text(
                        //               ' : ',
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Expanded(
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             verticalDirection: VerticalDirection.down,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               // Text(
                        //               //   '${list[index].transactionid}\t\t\n${list[index].date}\t\t\n${list[index].time}\t\t\n${list[index].tokenid}\t\t\n${list[index].tokenpoints}',
                        //               // ),

                        //               Text(
                        //                 '${list[index].date}',
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       crossAxisAlignment: CrossAxisAlignment.baseline,
                        //       textBaseline: TextBaseline.alphabetic,
                        //       children: [
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'তৈরির সময়',
                        //             ),

                        //             // Text(
                        //             //   'লেনদেন নাম্বার \t\t\nতৈরির তারিখ \t\t\nতৈরির সময় \t\t\nটোকেন আইডি\t\t\nটোকেন পয়েন্ট',
                        //             // ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             // Text(
                        //             //   ':\t\t\n:\t\t\n:\t\t\n:\t\t\n: ',
                        //             // ),
                        //             Text(
                        //               ' : ',
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Expanded(
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             verticalDirection: VerticalDirection.down,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               // Text(
                        //               //   '${list[index].transactionid}\t\t\n${list[index].date}\t\t\n${list[index].time}\t\t\n${list[index].tokenid}\t\t\n${list[index].tokenpoints}',
                        //               // ),
                        //               Text(
                        //                 '${list[index].time}',
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       crossAxisAlignment: CrossAxisAlignment.baseline,
                        //       textBaseline: TextBaseline.alphabetic,
                        //       children: [
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'টোকেন আইডি',
                        //             ),

                        //             // Text(
                        //             //   'লেনদেন নাম্বার \t\t\nতৈরির তারিখ \t\t\nতৈরির সময় \t\t\nটোকেন আইডি\t\t\nটোকেন পয়েন্ট',
                        //             // ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             // Text(
                        //             //   ':\t\t\n:\t\t\n:\t\t\n:\t\t\n: ',
                        //             // ),
                        //             Text(
                        //               ' : ',
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Expanded(
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             verticalDirection: VerticalDirection.down,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               // Text(
                        //               //   '${list[index].transactionid}\t\t\n${list[index].date}\t\t\n${list[index].time}\t\t\n${list[index].tokenid}\t\t\n${list[index].tokenpoints}',
                        //               // ),

                        //               Text(
                        //                 '${list[index].tokenid}',
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //     Row(
                        //       crossAxisAlignment: CrossAxisAlignment.baseline,
                        //       textBaseline: TextBaseline.alphabetic,
                        //       children: [
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Text(
                        //               'টোকেন পয়েন্ট',
                        //             ),

                        //             // Text(
                        //             //   'লেনদেন নাম্বার \t\t\nতৈরির তারিখ \t\t\nতৈরির সময় \t\t\nটোকেন আইডি\t\t\nটোকেন পয়েন্ট',
                        //             // ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           verticalDirection: VerticalDirection.down,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceEvenly,
                        //           children: [
                        //             // Text(
                        //             //   ':\t\t\n:\t\t\n:\t\t\n:\t\t\n: ',
                        //             // ),
                        //             Text(
                        //               ' : ',
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Expanded(
                        //           child: Column(
                        //             mainAxisSize: MainAxisSize.min,
                        //             verticalDirection: VerticalDirection.down,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               // Text(
                        //               //   '${list[index].transactionid}\t\t\n${list[index].date}\t\t\n${list[index].time}\t\t\n${list[index].tokenid}\t\t\n${list[index].tokenpoints}',
                        //               // ),
                        //               Text(
                        //                 '${list[index].tokenpoints}',
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ],
                        //     ),

                        //     // Row(
                        //     //   children: [
                        //     //     Column(
                        //     //       crossAxisAlignment: CrossAxisAlignment.start,
                        //     //       children: [
                        //     //         Text(
                        //     //             'লেনদেন নাম্বার : ${list[index].transactionid}'),
                        //     //         Text('তৈরির তারিখ : ${list[index].date}'),
                        //     //         Text('তৈরির সময় : ${list[index].time}'),
                        //     //         Text('টোকেন আইডি : ${list[index].tokenid}'),
                        //     //         Text(
                        //     //             'টোকেন পয়েন্ট : ${list[index].tokenpoints}'),
                        //     //       ],
                        //     //     ),
                        //     //     // Column(
                        //     //     //   crossAxisAlignment: CrossAxisAlignment.start,
                        //     //     //   children: [
                        //     //     //     Text(list[index].time),
                        //     //     //     Text(list[index].tokenid),
                        //     //     //     Text(list[index].tokenpoints),
                        //     //     //   ],
                        //     //     // )
                        //     //   ],
                        //     // ),
                        //     Divider()
                        //   ],
                        // );
                      },
                    ))
            ],
          ),
        ),
      )),
    );
  }
}

class TokenHistoryClass {
  var transactionid;
  var tokenid;
  var tokenpoints;
  var date;
  var time;
  var productcategory;

  TokenHistoryClass(
      {this.date,
      this.productcategory,
      this.time,
      this.tokenid,
      this.tokenpoints,
      this.transactionid});
}
