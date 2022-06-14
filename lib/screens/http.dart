import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

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
    var count = 0;
    for (Map chunk in hugedata["Result"]) {
      print(chunk);
      count += 1;
    }
    print(count);
    // print(hugedata["Result"]);
  }

  void getData2() async {
    //"timestamp": "2022-06-14T19:39:27+08:00",
    //YYYY-MM-DD[T]HH:mm:ss (SGT)
    var curTime =
        DateFormat('yyyy-mm-ddTkk:mm:ss+08:00').format(DateTime.now());
    Response data = await get(
      Uri.parse("https://api.data.gov.sg/v1/transport/carpark-availability"),
      headers: {
        "date_time": curTime,
      },
    );
    hugedata = jsonDecode(data.body);
    var count = 0;
    var carparkdata = hugedata["items"][0]["carpark_data"];
    print(carparkdata);
    for (Map chunk in carparkdata) {
      print(chunk);
      // print(chunk["carpark_info"]);
      // print(chunk["carpark_number"]);
      // print("___");
      count += 1;
    }
    print(count);
    // print(hugedata["Result"]);
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
            ElevatedButton(
              onPressed: () {
                getData2();
              },
              child: Text("GetDataDataGovSG"),
            ),
          ],
        ),
      ),
    );
  }
}
