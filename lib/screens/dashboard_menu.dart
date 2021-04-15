import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plumber_app/components/color.dart';
import 'package:plumber_app/provider/dialog/dialogs.dart';
import 'package:plumber_app/provider/dialog/user_details.dart';
import 'package:plumber_app/screens/barcode_scan_page.dart';
import 'package:plumber_app/screens/profile.dart';
import 'package:plumber_app/screens/token_tab.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    super.initState();
    //getProPic();
    porpic =
        'http://49.0.41.34/AKG/PLUMBER/image_show.php?user_id=${userDetails.userId}';
  }

  var porpic;
  Future getProPic() async {
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    // final DialaogsFucntion dialaogsFucntion =
    //     Provider.of<DialaogsFucntion>(context, listen: false);image_show
    //
    var url =
        Uri.parse('http://49.0.41.34/AKG/PLUMBER/image_show.php?user_id=1101');
    final response =
        await http.get(url).timeout(Duration(seconds: 25)).catchError((error) {
      print(error);
    });
    setState(() {
      porpic = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UserDetails userDetails =
        Provider.of<UserDetails>(context, listen: false);
    final DialaogsFucntion dialaogsFucntion =
        Provider.of<DialaogsFucntion>(context, listen: false);
    return WillPopScope(
      onWillPop: () => SystemNavigator.pop(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: size.height * 0.35,
                    width: size.width * 1,
                    //color: Colors.red,
                    child: Stack(
                      children: [
                        Container(
                          height: size.height * 0.3125,
                          width: size.width * 1,
                          decoration: BoxDecoration(
                            color: stella_red,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              img == null
                                  ? Hero(
                                      tag: 'proicon',
                                      child: Icon(
                                        Icons.account_circle,
                                        color: Colors.white,
                                        size: size.height * 0.15,
                                      ),
                                    )
                                  : Hero(
                                      tag: 'proicon',
                                      child: Container(
                                        height: size.height * 0.15,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white, width: 5),
                                            color: Colors.black87,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: porpic == null
                                                    ? NetworkImage(img)
                                                    : NetworkImage(porpic),
                                                fit: BoxFit.contain)),
                                      ),
                                    ),
                              userDetails.userId == null
                                  ? Text('id',
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1))
                                  : Text(
                                      '${userDetails.userId}'
                                      //userDetails.userId.toString()
                                      //salesPersonName
                                      ,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1)),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: size.height * 0.075,
                            width: size.width * 0.75,
                            // margin:
                            //     const EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Color(0xff404040)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                userDetails.userName == null
                                    ? Text('name')
                                    : Text('${userDetails.userName}',
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: stella_red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Card(
                    elevation: 0.5,
                    child: Container(
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BarCodeScanPage()));
                          },
                          leading: Container(
                            width: size.height * 0.08,
                            height: size.height * 0.08,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/qrcodescan.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text('টোকেন স্ক্যান করুন'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: stella_red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.5,
                    child: Container(
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: ListTile(
                          onTap: () async {
                            var result =
                                await Connectivity().checkConnectivity();
                            if (result == ConnectivityResult.none) {
                              print('no net');
                              dialaogsFucntion.noInternet(context);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TokenTabPages()));
                            }
                          },
                          leading: Container(
                            width: size.height * 0.08,
                            height: size.height * 0.08,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/coinlogo.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text('সকল টোকেনের হিসাব'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: stella_red,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.5,
                    child: Container(
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: ListTile(
                          onTap: () async {
                            var result =
                                await Connectivity().checkConnectivity();
                            if (result == ConnectivityResult.none) {
                              print('no net');
                              dialaogsFucntion.noInternet(context);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProfilePage()));
                            }
                          },
                          leading: Container(
                            width: size.height * 0.08,
                            height: size.height * 0.08,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('images/person.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text('আমার বিস্তারিত তথ্য'),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: stella_red,
                          ),
                        ),
                      ),
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
}
