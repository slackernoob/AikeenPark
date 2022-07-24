// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// class PreviewPage extends StatelessWidget {
//   const PreviewPage({Key? key, required this.picture}) : super(key: key);

//   final XFile? picture;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: const Text('Preview Page')),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.file(
//               File(picture!.path),
//               fit: BoxFit.cover,
//               width: 350,
//             ),
//             const SizedBox(height: 25),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton.icon(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(
//                       Icons.clear,
//                       color: Colors.red,
//                     ),
//                     label: const Text(
//                       "Retake",
//                       style: TextStyle(fontSize: 20),
//                     )),
//                 TextButton.icon(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.pop(context, picture);
//                     },
//                     icon: const Icon(
//                       Icons.check,
//                       color: Colors.red,
//                     ),
//                     label: const Text(
//                       "Submit",
//                       style: TextStyle(fontSize: 20),
//                     )),
//               ],
//             )
//             // Text(picture.name)
//           ],
//         ),
//       ),
//     );
//   }
// }
