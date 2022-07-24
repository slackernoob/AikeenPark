import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PreviewPage extends StatelessWidget {
  const PreviewPage({
    Key? key,
    required this.image,
    required this.location,
    required this.description,
  }) : super(key: key);

  final File? image;
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
              image!,
              fit: BoxFit.cover,
              width: 200,
            ),
            const SizedBox(height: 25),
            // Text("Picture Name: ${image!.name}"),
          ],
        ),
      ),
    );
  }
}
