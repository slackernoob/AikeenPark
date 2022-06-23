// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class googleMaps extends StatelessWidget {
//   // const googleMaps({Key? key}) : super(key: key);

//   static const CameraPosition initialCameraPosition = CameraPosition(
//     target: LatLng(1.3521, 103.8198),
//     zoom: 10.0,
//   );

//   Set<Marker> markersList;

//   GoogleMapController googleMapController;

//   googleMaps(this.markersList, this.googleMapController);

//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       initialCameraPosition: initialCameraPosition,
//       markers: markersList,
//       mapType: MapType.normal,
//       onMapCreated: (GoogleMapController controller) {
//         googleMapController = controller;

//         // _location.onLocationChanged.listen((l) {
//         //   googleMapController.animateCamera(
//         //     CameraUpdate.newCameraPosition(
//         //       CameraPosition(
//         //           target:
//         //               LatLng(l.latitude as double, l.longitude as double),
//         //           zoom: 15),
//         //     ),
//         //   );
//         // });
//       },
//       myLocationEnabled: true,
//       // circles: circles,
//     );
//   }
// }
