import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:plumber_app/components/color.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;
import 'package:plumber_app/provider/dialog/dialogs.dart';
import 'package:plumber_app/provider/dialog/user_details.dart';
import 'package:provider/provider.dart';

class BarCodeScanPage extends StatefulWidget {
  @override
  _BarCodeScanPageState createState() => _BarCodeScanPageState();
}

class _BarCodeScanPageState extends State<BarCodeScanPage> {
  String scanBarcode = 'Unknown';
  bool isloading = false;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      setState(() {
        scanBarcode = barcodeScanRes;
      });
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      scanBarcode = barcodeScanRes;
    });
  }

  Future tokenSubmit() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final DialaogsFucntion dialaogsFucntion =
        Provider.of<DialaogsFucntion>(context, listen: false);
    var url = Uri.parse('http://49.0.41.34/AKG/PLUMBER/token_point.php');
    final response = await http
        .post(
          url,
          encoding: Encoding.getByName("utf-8"),
          body: {
            "user_id": userDetails.userId,
            "token_id": scanBarcode,
          },
        )
        .timeout(Duration(seconds: 25))
        .catchError((error) {
          print(error);
        });
    var result = json.decode(response.body);

    if (result['success'] == 1) {
      setState(() {
        isloading = false;
        scanBarcode = 'Unknown';
      });
      dialaogsFucntion.msgDialog(context, 'ok');
      print(result);
    } else if (result['success'] == 0) {
      setState(() {
        isloading = false;
        scanBarcode = 'Unknown';
      });
      dialaogsFucntion.msgDialog(context, result['msg']);
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DialaogsFucntion dialaogsFucntion =
        Provider.of<DialaogsFucntion>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('টোকেন স্ক্যান'),
        centerTitle: true,
        backgroundColor: stella_red,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: size.height * 0.9,
          child: isloading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    scanBarcode == 'Unknown'
                        ? SizedBox()
                        : scanBarcode == '-1'
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text(
                                  'আপনার টোকেন',
                                  style: TextStyle(
                                      color: stella_red,
                                      fontSize: 20,
                                      letterSpacing: 1),
                                ),
                              ),
                    scanBarcode == 'Unknown'
                        ? SizedBox()
                        : scanBarcode == '-1'
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Container(
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Text(
                                      scanBarcode,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 20,
                                          letterSpacing: 1),
                                    ),
                                  ),
                                ),
                              ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    AvatarGlow(
                      endRadius: 80,
                      glowColor: Colors.green,
                      duration: Duration(milliseconds: 1000),
                      repeat: true,
                      showTwoGlows: true,
                      repeatPauseDuration: Duration(milliseconds: 100),
                      child: InkWell(
                        onTap: () {
                          scanBarcodeNormal();
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          child: Icon(
                            Icons.qr_code,
                            size: 50,
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Text(
                      'টোকেন স্ক্যান করুন',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    scanBarcode == 'Unknown'
                        ? SizedBox()
                        : scanBarcode == '-1'
                            ? SizedBox()
                            : SizedBox(
                                width: size.width * 0.8,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  onPressed: () async {
                                    var result = await Connectivity()
                                        .checkConnectivity();
                                    if (result == ConnectivityResult.none) {
                                      print('no net');
                                      dialaogsFucntion.noInternet(context);
                                    } else {
                                      setState(() {
                                        isloading = true;
                                      });
                                      tokenSubmit();
                                    }
                                  },
                                  color: Colors.green,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      'জমা দিন',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
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
