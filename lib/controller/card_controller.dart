import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CardController extends GetxController {
  RxInt bottomNavIndex = 2.obs;
  Color tcolor = Color(0xFF2dbc77);
  RxList data = [].obs;
  RxBool noData = true.obs;

  @override
  void onInit() {
    super.onInit();
    splashScreen();
  }

  void splashScreen() async {
    getApiData();
    await Future.delayed(Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(Duration(seconds: 1));
    print('go!');
    print(data.length);
    FlutterNativeSplash.remove();
  }

  List<Map<dynamic, dynamic>> iconList = [
    {"icon": Icons.home, "name": "Home"},
    {"icon": Icons.percent_rounded, "name": "Offers"},
    {"icon": Icons.credit_card, "name": "Card"},
    {"icon": Icons.account_circle, "name": "Account"}
  ];

  String cardNumber = '1234 5678 9032 1654';
  String expiryDate = '06/17';
  String cardHolderName = 'Softcent';
  String cvvCode = '123';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = true;
  OutlineInputBorder? border;

  void handleNavigationChange(BuildContext context, int index) {
    print(index);
    bottomNavIndex.value = index;
    // switch (index) {
    //   case 0:
    //     {
    //       print("Home");
    //     }
    //     break;
    //   case 1:
    //     {
    //       print("Profile");
    //     }
    //     break;
    // }
  }

  void getApiData() async {
    Uri url =
        Uri.parse("https://mocki.io/v1/4572d649-fda0-4c84-991d-08ba0961205d");
    data.clear();
    await http.get(url).then((response) {
      if (response.statusCode == 200) {
        var rowData = jsonDecode(response.body)['data'];
        if (rowData['transactions'].length > 0) {
          for (var dataItem in rowData['transactions']) {
            data.add(dataItem);
          }
          noData.value = false;
        } else {
          noData.value = true;
        }
      } else {
        noData.value = true;
      }
    });
  }
}
