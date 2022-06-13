import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Http extends StatefulWidget {
  // const Http({Key? key}) : super(key: key);

  @override
  State<Http> createState() => _HttpState();
}

class _HttpState extends State<Http> {
  late var tokenn;
  late var hugedata;

  void getToken() async {
    Response token = await get(
      Uri.parse("https://www.ura.gov.sg/uraDataService/insertNewToken.action"),
      headers: {
        "AccessKey": "9f963041-efc2-43f2-bfdc-70b4e9644102",
      },
    );
    tokenn = jsonDecode(token.body);
    print(token.body);
    print(tokenn["Result"]);
  }

  void getData() async {
    Response data = await get(
      Uri.parse(
          "https://www.ura.gov.sg/uraDataService/invokeUraDS?service=Car_Park_Availability"),
      headers: {
        "AccessKey": "9f963041-efc2-43f2-bfdc-70b4e9644102",
        "Token": tokenn["Result"],
      },
    );
    hugedata = jsonDecode(data.body);
    print(hugedata["Result"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                getToken();
              },
              child: Text("GetToken"),
            ),
            Text("Token received is HERE"),
            ElevatedButton(
              onPressed: () {
                getData();
              },
              child: Text("GetData"),
            ),
          ],
        ),
      ),
    );
  }
}
