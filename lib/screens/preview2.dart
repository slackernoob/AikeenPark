import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PreviewPage2 extends StatelessWidget {
  const PreviewPage2({
    Key? key,
    required this.picture,
    required this.location,
    required this.description,
  }) : super(key: key);

  final XFile? picture;
  final String location;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Preview Page'),
          backgroundColor: Colors.brown[400]),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Location: $location"),
            const SizedBox(height: 25),
            Text("Description: $description"),
            const SizedBox(height: 25),
            Image.file(
              File(picture!.path),
              fit: BoxFit.cover,
              width: 200,
            ),
            const SizedBox(height: 25),
            Text("Picture Name: ${picture!.name}"),
          ],
        ),
      ),
    );
  }
}
