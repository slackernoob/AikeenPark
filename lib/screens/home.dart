import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:aikeen_park/screens/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert';

// import 'package:google_place/google_place.dart' as plc;

import './search.dart';

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
          title: Text("Confirm LogOut?"),
          content: Text(
              "Logging out means you have to log in again, is this alright?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                _signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Sign out"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      });
}

const kGoogleApiKey = 'AIzaSyBApyJHUXxdUIBCBYkNNBPk7WuTIFVs7rE';

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _HomeState extends State<Home> {
  List nearbyCarparks = [];
  List availabilityInfo = [];

  var intCounter = 0;

  void getNearby(double lat, double lng) async {
    var apikey = "AIzaSyD-m4POdwpwfTtO_AtGG3bAekX3LzCt2FQ";
    // var googlePlace = GooglePlace(apikey);
    // // List<PlacesSearchResult> places = [];
    // var result = await googlePlace.search.getNearBySearch(
    //   Location(),
    //   1500,
    //   type: "parking",
    // );
    Response data = await get(
      Uri.parse(
          "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat}%2C${lng}&rankby=distance&type=parking&key=AIzaSyD-m4POdwpwfTtO_AtGG3bAekX3LzCt2FQ"),
      // location=lat%2Clng
    );
    var parsed = jsonDecode(data.body);
    var carparkdata = parsed["results"];
    var counter = 0;
    nearbyCarparks = [];
    for (Map thing in carparkdata) {
      nearbyCarparks.add([
        thing["name"],
        thing["geometry"]["location"]["lat"],
        thing["geometry"]["location"]["lng"],
        thing["geometry"]["location"]["lat"].toStringAsFixed(3),
        thing["geometry"]["location"]["lng"].toStringAsFixed(3),
      ]);
      print(thing["name"]);
      print(thing["geometry"]["location"]["lat"]);
      print(thing["geometry"]["location"]["lng"]);
      print("__");
      counter += 1;
      if (counter == 5) {
        break;
      }
    }
    double nearbyLat;
    double nearbyLng;
    String nearbyName;
    String stringLat;
    String stringLng;

    for (List info in availabilityInfo) {
      for (List lst in nearbyCarparks) {
        // print("comparing ${info[0]} to ${lst[4]}");
        // print(info[0].runtimeType);
        // print(info[1].runtimeType);
        // print(lst[2].runtimeType);
        // print(lst[1].runtimeType);

        if (((info[0] - lst[2]).abs() <= 0.0005) &&
            ((info[1] - lst[1]).abs() <= 0.0005)) {
          lst.add(info[2]);
        }
      }
    }
    for (List lst in nearbyCarparks) {
      if (lst.length == 5) {
        lst.add(-1);
      }
    }
    for (List lst in nearbyCarparks) {
      nearbyName = lst[0];
      nearbyLat = lst[1];
      nearbyLng = lst[2];
      stringLat = nearbyLat.toStringAsFixed(3);
      stringLng = nearbyLng.toStringAsFixed(3);
      int availLots = lst[5];
      addMarkers(nearbyLat, nearbyLng, intCounter, nearbyName, availLots);
      // print(nearbyLat);
      // print(nearbyLng);
      intCounter += 1;
    }
    setState(() {});
    print(nearbyCarparks);
    print(availabilityInfo);
  }

  void getDataMall() async {
    Response data = await get(
      Uri.parse(
          "http://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2"),
      headers: {
        "AccountKey": "2AKeuSk5TNqlLiPo4jc7lg==",
      },
    );
    var hugedata = jsonDecode(data.body);
    print(hugedata);
    var count = 0;
    for (Map chunk in hugedata["value"]) {
      var latlng = []; //["1.29115", "103.85728"]
      latlng = chunk["Location"].split(' ');
      // print(latlng[1] + ' ' + latlng[0]);
      double lat = double.parse(latlng[1]);
      double lng = double.parse(latlng[0]);
      // print(lat.toStringAsFixed(3));
      // print(lng.toStringAsFixed(3));

      print(chunk["AvailableLots"]);
      count += 1;
      availabilityInfo.add([
        lat, //.toStringAsFixed(3),
        lng, //.toStringAsFixed(3),
        chunk["AvailableLots"]
      ]);
    }
    print(availabilityInfo);
    print(count);
    // print(hugedata["Result"]);
  }

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(1.3521, 103.8198),
    zoom: 10.0,
  );

  Set<Marker> markersList = {};

  late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay; //or fullscren

  Set<Circle> circles = Set.from([
    Circle(
      circleId: CircleId("0"),
      center: LatLng(1.3521, 103.8198),
      radius: 4000,
      fillColor: Colors.blue.shade100.withOpacity(0.6),
      strokeColor: Colors.blue.shade100.withOpacity(0.1),
    )
  ]);

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
        actions: [
          IconButton(
            onPressed: () {
              showAlertDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markersList,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;

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
            circles: circles,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: currentIndex,
        // type: BottomNavigationBarType.fixed,
        onTap: (_) {
          getDataMall();
          _handlePressButton();
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
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

    var lat = detail.result.geometry!.location.lat;
    var lng = detail.result.geometry!.location.lng;

    markersList.clear();
    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    getNearby(lat, lng);

    setState(() {});
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }

  void addMarkers(
      double lat, double lng, int marker_ID, String name, int availLots) {
    markersList.add(Marker(
      markerId: MarkerId(marker_ID.toString()),
      position: LatLng(lat, lng), //position of marker
      infoWindow: InfoWindow(
        title: name, //'Marker Title Second ',
        snippet: availLots.toString(),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue), //markerbitmap
    ));
  }
}
