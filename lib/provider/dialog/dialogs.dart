import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plumber_app/provider/dialog/user_details.dart';
import 'package:provider/provider.dart';

class DialaogsFucntion extends ChangeNotifier {
  Future errorDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(left: 30, right: 30),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          //contentPadding: EdgeInsets.only(top: 10.0),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text("কিছু ভুল হয়েছে দয়া করে পরে আবার চেষ্টা করুন!",
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        decoration: TextDecoration.none)),
              ),
            ),
          ),
          actions: [
            Column(
              children: [
                TextButton(
                  child: Text(
                    'বাতিল করুন',
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  // Future nullUserDialog(BuildContext context, String msg) async {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       Size size = MediaQuery.of(context).size;
  //       return AlertDialog(
  //         actionsPadding: EdgeInsets.only(left: 30, right: 30),
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //         content: Container(
  //           height: size.height * 0.25,
  //           child: Center(
  //             child: Text(msg,
  //                 overflow: TextOverflow.clip,
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                     letterSpacing: 0.5,
  //                     decoration: TextDecoration.none)),
  //           ),
  //         ),
  //         actions: [
  //           Column(
  //             children: [
  //               RoundedButton(
  //                 color: loginbtn1,
  //                 text: 'রেজিস্ট্রেশন করুন',
  //                 fontSize: 15,
  //                 press: () {
  //                   Navigator.push(context,
  //                       MaterialPageRoute(builder: (_) => UserSelectionPage()));
  //                 },
  //               ),
  //               RoundedButton(
  //                 color: Colors.red[300],
  //                 text: 'বাতিল করুন',
  //                 fontSize: 15,
  //                 press: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ],
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  //
  //
  //
  //
  Future profilePic(BuildContext context) async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final profilepics =
        'http://49.0.41.34/AKG/PLUMBER/image_show.php?user_id=1101';

    userDetails.dataImgLink(profilepics);
  }

  Future msgDialog(BuildContext context, String msg) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        //Size size = MediaQuery.of(context).size;
        return AlertDialog(
          actionsPadding: EdgeInsets.only(left: 30, right: 30),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: Container(
            //height: size.height * 0.15,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(msg,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        decoration: TextDecoration.none)),
              ],
            ),
          ),
          actions: [
            Column(
              children: [
                TextButton(
                  child: Text(
                    'বাতিল করুন',
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future exitDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.only(left: 30, right: 30),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          //contentPadding: EdgeInsets.only(top: 10.0),

          content: Container(
            //height: size.height * 0.2,
            // color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: size.height * 0.07,
                      width: size.height * 0.07,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Text("আপনি কি অ্যাপ্লিকেশন থেকে বের হতে চান?",
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          decoration: TextDecoration.none)),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: InkWell(
                  onTap: () {
                    SystemNavigator.pop();
                  },
                  child: Text(
                    'হ্যাঁ',
                  )),
            ),
            // SizedBox(width: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'না',
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future noInternet(BuildContext context) async {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      backgroundColor: Colors.red[600],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      behavior: SnackBarBehavior.floating,
      content: Text(
        'দয়া করে আপনার মোবাইলের ইন্টারনেট সংযোগটি পরীক্ষা করুন!',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
    ));
  }
}
