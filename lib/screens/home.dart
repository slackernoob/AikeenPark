import 'package:aikeen_park/constants.dart';
import 'package:aikeen_park/screens/userInput.dart';
import 'package:aikeen_park/screens/directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:location/location.dart' as loc;
// import 'package:aikeen_park/screens/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:permission_handler/permission_handler.dart';

// import './search.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

showAlertDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm LogOut?"),
          content: const Text(
              "Logging out means you have to log in again, is this alright?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                _signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("Sign out"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      });
}

void _showDirections(BuildContext ctx, List closest, Function _goToPlace,
    Function _setPolyline) {
  showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.3,
          child: showDirections(closest, _goToPlace, _setPolyline,
              _polylineIdCounter, _polylines),
        );
      });
}

const CameraPosition initialCameraPosition = CameraPosition(
  target: LatLng(1.3521, 103.8198),
  zoom: 10.0,
);

Set<Marker> markersList = {};
Set<Polyline> _polylines = Set<Polyline>();

int _polylineIdCounter = 1;

late GoogleMapController googleMapController;

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _HomeState extends State<Home> {
  List nearbyCarparks = [];
  List availabilityInfo = [];
  List closest = [];

  var intCounter = 0;

  void getNearby(double lat, double lng) {
    int l = availabilityInfo.length - 1;
    var curDist;
    int i = 0;
    for (i; i < l; i++) {
      curDist = Geolocator.distanceBetween(
        lat,
        lng,
        availabilityInfo[i][0],
        availabilityInfo[i][1],
      );
      availabilityInfo[i].add(curDist);
    }
    var curMin = 5000.0;
    var cur;
    var curIndex;
    i = 0;

    closest.clear();
    for (int count = 0; count < 5; count++) {
      i = 0;
      for (i; i < l; i++) {
        // print(availabilityInfo[i]);
        if (availabilityInfo[i].length == 5) {
          availabilityInfo[i].add(10000.0);
        }
        cur = availabilityInfo[i][5];
        if (cur <= curMin && (closest.contains(i) == false)) {
          curMin = cur;
          curIndex = i;
          // print("test");
        }
      }
      closest.add(availabilityInfo[curIndex]);
      availabilityInfo.removeAt(curIndex);
      l = availabilityInfo.length;
      curMin = 5000.0;
    }

    double nearbyLat;
    double nearbyLng;
    String nearbyName;

    for (List lst in closest) {
      nearbyName = lst[3];
      nearbyLat = lst[0];
      nearbyLng = lst[1];
      int availLots = lst[2];
      addMarkers(nearbyLat, nearbyLng, intCounter, nearbyName, availLots);
      // print(nearbyLat);
      // print(nearbyLng);
      intCounter += 1;
    }
    // print(closest);
    setState(() {});
  }

  void getDataMall() async {
    http.Response data = await http.get(
      Uri.parse(
          "http://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2"),
      headers: {
        "AccountKey": "2AKeuSk5TNqlLiPo4jc7lg==",
      },
    );
    var hugedata = jsonDecode(data.body);
    // print(hugedata);
    var count = 0;
    availabilityInfo = [];
    for (Map chunk in hugedata["value"]) {
      var latlng = [];
      latlng = chunk["Location"].split(' ');
      double lat = double.parse(latlng[0]);
      double lng = double.parse(latlng[1]);
      count += 1;
      availabilityInfo.add([
        lat,
        lng,
        chunk["AvailableLots"],
        chunk["Development"],
        chunk["LotType"],
      ]);
    }
  }

  final Mode _mode = Mode.overlay;

  // Set<Circle> circles = Set.from([
  //   Circle(
  //     circleId: CircleId("0"),
  //     center: LatLng(1.3521, 103.8198),
  //     radius: 4000,
  //     fillColor: Colors.blue.shade100.withOpacity(0.6),
  //     strokeColor: Colors.blue.shade100.withOpacity(0.1),
  //   )
  // ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading:
            false, //removes backarrow on extreme left of appbar
        title: const Text(
          "AikeenPark",
        ),
        backgroundColor: Colors.brown[400],
        actions: [
          IconButton(
            onPressed: () {
              getDataMall();
              _handlePressButton();
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              showAlertDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markersList,
        polylines: _polylines,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
          request();

          // _location.onLocationChanged.listen((l) {
          //   googleMapController.animateCamera(
          //     CameraUpdate.newCameraPosition(
          //       CameraPosition(
          //           target:
          //               LatLng(l.latitude as double, l.longitude as double),
          //           zoom: 15),
          //     ),
          //   );
          // });
        },
        myLocationEnabled: true,
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.message),
              label: 'User Feedback',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => userInput(),
                  ),
                );
              }),
          SpeedDialChild(
              child: Icon(Icons.list_alt),
              label: 'Carpark List',
              onTap: () {
                if (closest[0][0] == null) {
                  return;
                }
                _showDirections(
                  context,
                  closest,
                  _goToPlace,
                  _setPolyline,
                );
              }),
        ],
      ),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [Component(Component.country, "Sg")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    var Lat = detail.result.geometry!.location.lat;
    var Lng = detail.result.geometry!.location.lng;

    markersList.clear();

    getNearby(Lat, Lng);

    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(Lat, Lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    _polylines.clear();
    setState(() {});
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(Lat, Lng), 14.0));
  }

  Future<void> _goToPlace(
    double lat,
    double lng,
    Map<String, dynamic> boundsNe,
    Map<String, dynamic> boundsSw,
  ) async {
    // googleMapController
    //     .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
    googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
        northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
      ),
      25,
    ));
    setState(() {});
  }

  // Future<Map<String, dynamic>> getDirections(
  //     String origin, String destination) async {
  //   final String url =
  //       'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$kGoogleApiKey';
  //   var response = await http.get(Uri.parse(url));
  //   var json = jsonDecode(response.body);

  //   var results = {
  //     'bounds_ne': json['routes'][0]['bounds']['northeast'],
  //     'bounds_sw': json['routes'][0]['bounds']['southwest'],
  //     'start_location': json['routes'][0]['legs'][0]['start_location'],
  //     'end_location': json['routes'][0]['legs'][0]['end_location'],
  //     'polyline': json['routes'][0]['overview_polyline']['points'],
  //     'polyline_decoded': PolylinePoints()
  //         .decodePolyline(json['routes'][0]['overview_polyline']['points']),
  //   };
  //   return results;
  // }

  void addMarkers(
      double lat, double lng, int marker_ID, String name, int availLots) {
    markersList.add(Marker(
      markerId: MarkerId(marker_ID.toString()),
      position: LatLng(lat, lng), //position of marker
      infoWindow: InfoWindow(
        title: name, //'Marker Title Second ',
        snippet: 'Carpark Lots: ' + availLots.toString(),
      ),
      onTap: () {
        // _showDirections(ctx, closest, _goToPlace, _setPolyline);
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue), //markerbitmap
    ));
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$_polylineIdCounter';
    _polylineIdCounter += 1;
    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.red,
        points: points
            .map(
              (points) => LatLng(points.latitude, points.longitude),
            )
            .toList(),
      ),
    );
  }

  void request() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    // Ask permission from device
    Future<void> requestPermission() async {
      await Permission.location.request();
    }
  }
}
