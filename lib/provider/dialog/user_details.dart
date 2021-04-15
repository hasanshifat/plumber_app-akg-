import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class UserDetails extends ChangeNotifier {
  var userName;
  var userId;
  var authCode;
  var phoneNumber;
  var imglink;

  dataUserName(var username) {
    userName = username;
    notifyListeners();
  }
  dataImgLink(var imglink) {
    imglink = imglink;
    notifyListeners();
  }

  dataUserID(var uid) {
    userId = uid;
    notifyListeners();
  }

  dataAuthCode(var authode) {
    authCode = authode;
    notifyListeners();
  }

  dataPhoneNumber(var phonenumber) {
    phoneNumber = phonenumber;
    notifyListeners();
  }
}
