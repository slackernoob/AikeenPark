import 'dart:io';

import 'package:aikeen_park/screens/camera.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'dart:io' as io;

class userInput extends StatefulWidget {
  @override
  State<userInput> createState() => _userInputState();
}

class _userInputState extends State<userInput> {
  // const MyWidget({Key? key}) : super(key: key);
  final locationController = TextEditingController();

  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;
    void addData() {
      firestoreInstance.collection("userinput").add(
        {
          "location": locationController.text,
          "description": descriptionController.text,
        },
      ).then((documentSnapshot) =>
          print("Added Data with ID: ${documentSnapshot.id}"));
    }

    // final CollectionReference collectionRef =
    //     FirebaseFirestore.instance.collection("userinput");

    // List dataList = [];

    // Future getData() async {
    //   try {
    //     await collectionRef.get().then((querySnapshot) {
    //       for (var result in querySnapshot.docs) {
    //         dataList.add(result.data());
    //       }
    //       print(dataList[0]['description']);
    //     });
    //   } catch (e) {
    //     debugPrint("Error - $e");
    //     return e;
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            style: GoogleFonts.montserrat(
              fontSize: 30,
              color: Colors.white,
            ),
            "User Input",
          ),
          backgroundColor: Colors.brown[400],
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            IconButton(
              onPressed: () {
                // getData();
              },
              icon: const Icon(Icons.data_array),
            ),
          ]),
      body: Card(
        //elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                    labelText: 'Location/Street Name',
                    hintText: 'eg. Toa Payoh Lorong 8 / Yishun Avenue 6'),
                controller: locationController,
                // onSubmitted: (_) => submitData(),

                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'eg. Underground carpark / Multi-Story Carpark'),
                controller: descriptionController,
                // onSubmitted: (_) => submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              const SizedBox(height: 20),
              Center(
                // alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    await availableCameras().then((value) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CameraPage(cameras: value)));
                    });
                    // await availableCameras().then((value) => Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => CameraPage(cameras: value))));
                  },
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xffFDCF09),
                    child:
                        // _photo != null
                        //     ? ClipRRect(
                        //         borderRadius: BorderRadius.circular(50),
                        //         child: Image.file(
                        //           _photo!,
                        //           width: 100,
                        //           height: 100,
                        //           fit: BoxFit.fitHeight,
                        //         ),
                        //       )
                        //     :
                        Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50)),
                      width: 100,
                      height: 100,
                      child: Icon(
                        Icons.add_a_photo_sharp,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    // print(firestoreInstance);
                    addData();
                    locationController.clear();
                    descriptionController.clear();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.brown),
                  child: const Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}
