import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            ]),
        body: Card(
          //elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
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
                      hintText:
                          'eg. Underground carpark / Multi-Story Carpark'),
                  controller: descriptionController,
                  // onSubmitted: (_) => submitData(),
                  // onChanged: (val) => amountInput = val,
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
        ));
  }
}
