import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<List> getData() async {
    List dataList = [];

    await collectionRef.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        dataList.add(result.data());
      }
    });

    return dataList;
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.clear),
            ),
          ]),
      body: FutureBuilder<List>(
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
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: ListTile(
                    title: Text(
                      "Location: ${dataList[index]['location']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text("Description: ${dataList[index]['description']}"),
                    leading: IconButton(
                      icon:
                          const Icon(Icons.check, color: Colors.red, size: 30),
                      onPressed: () {}, //mayb delete from firebase
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {}, //mayb delete from firebase
                    ),
                    onTap: () {}, //mayb show preview of image here
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
