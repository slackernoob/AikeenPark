import 'package:flutter/material.dart';
import '../storage_service.dart';

class DisplayPage extends StatefulWidget {
  final String imgName;

  DisplayPage(this.imgName);

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  final Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storage.downloadURL(widget.imgName),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return SizedBox(
              width: 150,
              height: 150,
              child: Image.network(
                snapshot.data!,
                fit: BoxFit.contain,
              ));
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return Container();
      },
    );
  }
}
