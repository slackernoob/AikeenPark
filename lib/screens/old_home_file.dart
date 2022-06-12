// import 'package:aikeen_park/screens/log_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import './search.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// Future<void> _signOut() async {
//   await FirebaseAuth.instance.signOut();
// }

// showAlertDialog(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm LogOut?"),
//           content: Text(
//               "Logging out means you have to log in again, is this alright?"),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 _signOut();
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//               },
//               child: Text("Sign out"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Cancel"),
//             ),
//           ],
//         );
//       });
// }

// class _HomeState extends State<Home> {
//   late GoogleMapController mapController;
//   final LatLng _singapore = const LatLng(45.521563, -122.677433);

//   void _onMapCreated(GoogleMapController mapController) {
//     this.mapController = mapController;
//   }

//   // int currentIndex = 0;

//   // final screens = [
//   //   const SearchPlace(),
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading:
//             false, //removes backarrow on extreme left of appbar
//         title: const Text(
//           "AikeenPark",
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               showAlertDialog(context);
//             },
//             icon: const Icon(Icons.logout),
//           )
//         ],
//       ),
//       body: Container(
//         child: GoogleMap(
//           mapType: MapType.normal,
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: _singapore,
//             zoom: 10,
//             // tilt: 0,
//             // bearing: 0,
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         // currentIndex: currentIndex,
//         // type: BottomNavigationBarType.fixed,
//         // onTap: ((index)),
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.map),
//             label: "Map",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: "Search",
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
// }
