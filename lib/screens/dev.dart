import 'package:aikeen_park/screens/displayIMG.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DevModeScreen extends StatefulWidget {
  const DevModeScreen({Key? key}) : super(key: key);

  @override
  State<DevModeScreen> createState() => _DevModeScreenState();
}

class _DevModeScreenState extends State<DevModeScreen> {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("userinput");

  final firestoreInstance = FirebaseFirestore.instance;

  Future<List> getData() async {
    List dataList = [];

    await collectionRef.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        dataList.add(result.data());
      }
    });

    return dataList;
  }

  Future deleteData(String docID) async {
    await firestoreInstance.collection("userinput").doc(docID).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: GoogleFonts.montserrat(
            fontSize: 30,
            color: Colors.white,
          ),
          "Dev Mode",
        ),
        backgroundColor: Colors.brown[400],
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       // final results = await FilePicker.platform.pickFiles(
        //       //   allowMultiple: false,
        //       //   type: FileType.custom,
        //       //   allowedExtensions: ['png', 'jpg'],
        //       // );

        //       // if (results == null) {
        //       //   ScaffoldMessenger.of(context).showSnackBar(
        //       //     const SnackBar(
        //       //       content: Text("No file selected"),
        //       //     ),
        //       //   );
        //       //   return;
        //       // }

        //       // final path = results.files.single.path!;
        //       // final fileName = results.files.single.name;

        //       // storage.uploadFile(path, "img1").then((value) => print("Done"));

        //       // print(path);
        //       // print(fileName);
        //     },
        //     icon: const Icon(Icons.clear),
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  List dataList = snapshot.data!;

                  return ListView.separated(
                    itemCount: dataList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      color: Colors.brown,
                      thickness: 5,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(
                            "Location: ${dataList[index]['location']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              "Description: ${dataList[index]['description']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 30),
                            onPressed: () {
                              setState(() {
                                deleteData(dataList[index]['doc ID']);
                              });
                            }, // delete from firebase
                          ),
                          onTap: () {
                            String imgName = dataList[index]['image name'];
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DisplayPage(imgName),
                              ),
                            );
                          }, //show preview of image here
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            color: Colors.brown,
            height: 50,
            child: const Center(child: Text("Click on tile to show image")),
            // width: 100,
          )
        ],
      ),
    );
  }
}
