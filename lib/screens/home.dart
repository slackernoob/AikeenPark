import 'package:aikeen_park/constants.dart';
import 'package:aikeen_park/screens/favorite.dart';
import 'package:aikeen_park/screens/userInput.dart';
import 'package:aikeen_park/screens/directions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'dart:async';

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

late Position _currentPosition;

_getCurrentLocation() {
  Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true)
      .then((Position position) {
    _currentPosition = position;
  }).catchError((e) {
    print(e);
  });
}

void _showDirections(BuildContext ctx, List closest, Function goToMarker,
    Function moveCamera, String dropdownvalue, Function setPolyline) {
  showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(ctx).size.height * 0.3,
          child: showDirections(closest, goToMarker, moveCamera, setPolyline,
              dropdownvalue, _polylines, _currentPosition, _getCurrentLocation),
        );
      });
}

const CameraPosition initialCameraPosition = CameraPosition(
  target: LatLng(1.3521, 103.8198),
  zoom: 10.0,
);

Set<Marker> markersList = {};
Set<Polyline> _polylines = <Polyline>{}; //Set<Polyline>();

int _polylineIdCounter = 1;

late GoogleMapController googleMapController;

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _HomeState extends State<Home> {
  List nearbyCarparks = [];
  List availabilityInfo = [];
  List closest = [];

  List urmum = [];

  var intCounter = 0;

  void getNearby(double lat, double lng) {
    int l = availabilityInfo.length; // -1;
    int i = 0;
    for (i; i < l; i++) {
      var curDist = Geolocator.distanceBetween(
        lat,
        lng,
        availabilityInfo[i][0],
        availabilityInfo[i][1],
      );
      availabilityInfo[i].add(curDist);
    }
    availabilityInfo.sort((a, b) => a[5].compareTo(b[5]));

    closest.clear();
    for (int i = 0; i < int.parse(dropdownvalue); i++) {
      closest.add(availabilityInfo[i]);
    }

    double nearbyLat;
    double nearbyLng;
    String nearbyName;
    String parkingType;

    for (List lst in closest) {
      nearbyName = lst[3];
      nearbyLat = lst[0];
      nearbyLng = lst[1];
      int availLots = lst[2];
      parkingType = lst[4];
      addMarkers(
          nearbyLat, nearbyLng, intCounter, nearbyName, availLots, parkingType);
      // print(nearbyLat);
      // print(nearbyLng);
      intCounter += 1;
    }
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
    // var count = 0;
    availabilityInfo = [];
    for (Map chunk in hugedata["value"]) {
      var latlng = [];
      latlng = chunk["Location"].split(' ');
      double lat = double.parse(latlng[0]);
      double lng = double.parse(latlng[1]);
      // count += 1;
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

  bool switchValue = false;
  bool isVisible = true;

  // Initial Selected Value
  String dropdownvalue = '5';

  // List of items in our dropdown menu
  var items = [
    '5',
    '10',
    '15',
    '20',
  ];

  // late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    markersList.clear();
    _polylines.clear();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading:
            false, //removes backarrow on extreme left of appbar
        title: Text(
          style: GoogleFonts.montserrat(
            fontSize: 30,
            color: Colors.white,
          ),
          "AikeenPark",
        ),
        backgroundColor: Colors.brown[400],
        actions: [
          // Visibility(
          //   visible: isVisible,
          //   child: IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.developer_mode),
          //   ),
          // ),
          // Switch(
          //   value: switchValue,
          //   onChanged: (value) {
          //     switchValue = value;
          //     isVisible = !isVisible;
          //     setState(() {});
          //   },
          // ),
          DropdownButton(
            value: dropdownvalue,
            dropdownColor: Colors.brown,
            style: const TextStyle(color: Colors.white),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(
                  items,
                  // style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue = newValue!;
              });
            },
            onTap: () {},
          ),
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
        mapType: MapType.hybrid,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
          markersList.clear;
          _polylines.clear;
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
        backgroundColor: Colors.brown[400],
        overlayColor: Colors.brown[50],
        overlayOpacity: 0.4,
        spacing: 8,
        spaceBetweenChildren: 8,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.my_location, color: Colors.brown),
              label: 'Search around User',
              onTap: () {
                getDataMall();
                async1();
                // print(closest);
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text("Sending Message"),
                // ));
              }),
          SpeedDialChild(
              child: const Icon(Icons.feedback, color: Colors.brown),
              label: 'User Feedback',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => userInput(),
                  ),
                );
              }),
          SpeedDialChild(
              child: const Icon(Icons.list_alt, color: Colors.brown),
              label: 'Carpark List',
              onTap: () {
                if (closest[0][0] == null) {
                  return;
                }
                _showDirections(
                  context,
                  closest,
                  _goToMarker,
                  moveCamera,
                  dropdownvalue,
                  _setPolyline,
                );
              }),
          SpeedDialChild(
              child: const Icon(Icons.clear, color: Colors.brown),
              label: 'Clear All',
              onTap: () {
                _showAlert(context);
              }
              // closest.clear();
              // markersList.clear();
              // _polylines.clear();
              // setState(() {});
              ),
          SpeedDialChild(
              child: const Icon(Icons.bookmarks, color: Colors.brown),
              label: 'Bookmarks',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyFavorites(),
                  ),
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
                borderSide: const BorderSide(color: Colors.white))),
        components: [Component(Component.country, "Sg")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    // homeScaffoldKey.currentState!
    ScaffoldMessenger.of(context)
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

    getNearby(lat, lng);

    markersList.add(Marker(
        markerId: const MarkerId("0"),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: detail.result.name)));

    _polylines.clear();
    setState(() {});
    // googleMapController
    //     .animateCamera(CameraUpdate.newLatLngZoom(LatLng(Lat, Lng), 14.0));
    moveCamera(lat, lng);
  }

  Future<void> _goToMarker(
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
      40,
    ));
    setState(() {});
  }

  void moveCamera(double lat, double lng) {
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
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

  void addMarkers(double lat, double lng, int markerID, String name,
      int availLots, String parkingType) {
    markersList.add(Marker(
      markerId: MarkerId(markerID.toString()),
      position: LatLng(lat, lng), //position of marker
      infoWindow: InfoWindow(
        title: name, //'Marker Title Second ',
        snippet: 'Carpark Lots: $availLots',
      ),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Parking Type: $parkingType"),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Color.fromARGB(255, 1, 35, 63),
            onPressed: () {},
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.brown,
        ));
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

  // _getCurrentLocation() {
  //   Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.best,
  //           forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     _currentPosition = position;
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text("Clear Everything"),
            content: const Text(
                'This will remove all pins and routes, are you sure?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      closest.clear();
                      markersList.clear();
                      _polylines.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      )))
            ],
          );
        });
  }

  Future<void> async1() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    var lat = _currentPosition.latitude;
    var lng = _currentPosition.longitude;
    markersList.clear();
    getNearby(lat, lng);
    _polylines.clear();
    setState(() {});
    moveCamera(lat, lng);
  }
}
