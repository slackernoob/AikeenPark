import 'dart:io';

// import 'package:aikeen_park/screens/camera.dart';
import 'package:aikeen_park/screens/preview.dart';
// import 'package:aikeen_park/screens/previewcam.dart';
// import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../storage_service.dart';

class userInput extends StatefulWidget {
  @override
  State<userInput> createState() => _userInputState();
}

class _userInputState extends State<userInput> {
  // const MyWidget({Key? key}) : super(key: key);
  final locationController = TextEditingController();

  final descriptionController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  String location = '';
  String description = '';

  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) {
        return;
      }
      final tempImage = File(image.path);
      setState(() => this.image = tempImage);
    } on PlatformException catch (e) {
      print('failed to choose image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;

    final Storage storage = Storage();

    void addData() {
      firestoreInstance.collection("userinput").add(
        {
          "location": locationController.text,
          "description": descriptionController.text,
          "image name": basename(image!.path),
          "doc ID": '',
        },
      ).then((documentSnapshot) =>
          // print("Added Data with ID: ${documentSnapshot.id}");
          firestoreInstance
              .collection("userinput")
              .doc(documentSnapshot.id)
              .update({'doc ID': documentSnapshot.id}));

      String baseName = basename(image!.path);
      storage.uploadFile(image!.path, baseName).then((value) => print("Done"));
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
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(Icons.arrow_back),
        //   ),
        // ],
      ),
      body: Form(
        key: formkey,
        //elevation: 5,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      location = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter location";
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white60,
                      labelText: 'Location/Street Name',
                      hintText: 'eg. Toa Payoh Lorong 8 / Yishun Avenue 6',
                      // prefixIcon: Icon(Icons.location_city, color: Colors.black),
                    ),
                    controller: locationController,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      description = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter description";
                      }
                      return null;
                    },
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white60,
                      labelText: 'Description',
                      hintText: 'eg. Underground carpark / Multi-Story Carpark',
                      // prefixIcon: Icon(Icons.description, color: Colors.black),
                    ),
                    controller: descriptionController,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.brown),
                    child: const Text("Pick image from gallery"),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          pickImage(ImageSource.camera);
                        },
                        // onTap: () async {
                        //   await availableCameras().then((value) async {
                        //     picture = await Navigator.of(context).push(
                        //         MaterialPageRoute(
                        //             builder: (BuildContext context) =>
                        //                 CameraPage(cameras: value)));
                        //   });
                        //   // await availableCameras().then((value) => Navigator.push(
                        //   //     context,
                        //   //     MaterialPageRoute(
                        //   //         builder: (_) => CameraPage(cameras: value))));
                        //   // print(picture.name);
                        //   _showTips(context);
                        // },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xffFDCF09),
                          child: image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    image!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 100,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_sharp,
                                        color: Colors.grey[800],
                                      ),
                                      const Text(
                                        "Camera",
                                        style: TextStyle(color: Colors.brown),
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (image == null) {
                                _showMsg(context, "No image selected");
                                return;
                              }
                              if (formkey.currentState!.validate()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PreviewPage(
                                              image: image!,
                                              location: locationController.text
                                                  .toString(),
                                              description: descriptionController
                                                  .text
                                                  .toString(),
                                            )));
                              }
                            },
                            style:
                                ElevatedButton.styleFrom(primary: Colors.brown),
                            child: const Text("Show Preview"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (image == null) {
                                _showMsg(context, "No image selected");
                                return;
                              }
                              if (formkey.currentState!.validate()) {
                                _showMsg(context, "Thank you for your input");
                                addData();
                                locationController.clear();
                                descriptionController.clear();
                              }
                            },
                            style:
                                ElevatedButton.styleFrom(primary: Colors.brown),
                            child: const Text("Submit"),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     String baseName = basename(image!.path);
                          //     storage
                          //         .uploadFile(image!.path, baseName)
                          //         .then((value) => print("Done"));
                          //   },
                          //   style:
                          //       ElevatedButton.styleFrom(primary: Colors.brown),
                          //   child: const Text("test"),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMsg(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(msg),
            // content: const Text(),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      )))
            ],
          );
        });
  }
}
