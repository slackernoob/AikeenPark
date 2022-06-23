import 'package:flutter/material.dart';

class userInput extends StatelessWidget {
  // const MyWidget({Key? key}) : super(key: key);

  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              "User Input",
            ),
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
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Location'),
                  controller: locationController,
                  // onSubmitted: (_) => submitData(),

                  // onChanged: (val) {
                  //   titleInput = val;
                  // },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  controller: descriptionController,
                  // onSubmitted: (_) => submitData(),
                  // onChanged: (val) => amountInput = val,
                ),
              ],
            ),
          ),
        ));
  }
}
