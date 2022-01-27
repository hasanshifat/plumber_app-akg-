import 'package:flutter/material.dart';

class CustomFunctions {
  final String msg;
  const CustomFunctions({@required this.msg});

  // static showToast(BuildContext context, String msg) {
  //   return ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('$msg'),
  //     ),
  //   );
  // }

  static snackbar(BuildContext context, String msg) async {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      backgroundColor: Color(0xff393939),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      behavior: SnackBarBehavior.floating,
      content: Text(
        '$msg',
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 3),
    ));
  }

  static waitDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Center(

                // Aligns the container to center
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              // A simplified version of dialog.
              width: size.height * .15,
              height: size.height * .15,

              child: Center(
                child: CircularProgressIndicator(),
              ),
            )));
  }

  
}
