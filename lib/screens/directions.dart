import 'package:aikeen_park/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class showDirections extends StatefulWidget {
  // const showDirections({Key? key}) : super(key: key);

  final List closest;
  final Function goToMarker;
  final Function moveCamera;
  final Function setPolyline;
  final Set<Polyline> _polylines;
  final Position currentPosition;
  final Function getCurrentLocation;
  final List favCarparks;
  bool isSaved;

  showDirections(
      this.closest,
      this.goToMarker,
      this.moveCamera,
      this.setPolyline,
      this._polylines,
      this.currentPosition,
      this.getCurrentLocation,
      this.favCarparks,
      this.isSaved);

  @override
  State<showDirections> createState() => _showDirectionsState();
}

class _showDirectionsState extends State<showDirections> {
  // late Position _currentPosition;

  // Initial Selected Value
  String dropdownvalue = 'Highest Availability';

  // List of items in our dropdown menu
  var items = [
    'Highest Availability',
    'Lowest Availability',
    'Furthest',
    'Nearest',
  ];

  var textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    widget.getCurrentLocation();
    widget.closest.sort((a, b) => b[2].compareTo(a[2]));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(children: [
              Text(
                "DIRECTIONS",
                // style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.directions),
            ]),
            const SizedBox(width: 35),
            DropdownButton(
              value: dropdownvalue,
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.brown,
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
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
                  sortClosest(dropdownvalue);
                });
              },
              onTap: () {},
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: ListView.separated(
            // padding: const EdgeInsets.only(top: 2),
            itemCount: widget.closest.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              List savedFavs = widget.closest[index];
              bool isSaved = widget.favCarparks.contains(savedFavs);

              return directionCard(index, isSaved, savedFavs);
            },
          ),
          //     ListView(
          //   padding: const EdgeInsets.only(top: 2),
          //   children: createDirections(),
          // ),
        ),
      ],
    );
  }

  // List<Widget> createDirections() {
  //   List<Widget> directionCards = [];
  //   for (int i = 0; i < int.parse(widget.dropdownvalue); i++) {
  //     textColor = Colors.black;
  //     if (widget.closest[i][2] == 0) {
  //       textColor = Colors.red;
  //     }
  //     directionCards.add(directionCard(i));
  //   }
  //   return directionCards;
  // }

  Widget directionCard(int i, bool isSaved, List savedFavs) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: 112,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Divider(
            color: Color.fromARGB(255, 192, 78, 37),
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  widget.moveCamera(widget.closest[i][0], widget.closest[i][1]);
                },
                icon: const Icon(Icons.gps_fixed),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.closest[i][3],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown[400],
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  onPressed: () async {
                    widget._polylines.clear();
                    // _getCurrentLocation();
                    // locatePosition();
                    var directions = await getDirections(
                      widget.currentPosition,
                      // _currentPosition.latitude.toString(),
                      // _currentPosition.longitude.toString(),
                      widget.closest[i][0].toString(),
                      widget.closest[i][1].toString(),
                    );
                    widget.setPolyline(directions['polyline_decoded']);
                    widget.goToMarker(
                      directions['start_location']['lat'],
                      directions['start_location']['lng'],
                      directions['bounds_ne'],
                      directions['bounds_sw'],
                    );
                  },
                  child: const Text("Select route")),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (isSaved) {
                      widget.favCarparks.remove(savedFavs);
                    } else {
                      widget.favCarparks.add(savedFavs);
                    }
                  });
                  // widget.isSaved =
                  //     widget.favCarparks.contains(widget.closest[i]);
                  // // setState(() {
                  // if (widget.isSaved) {
                  //   widget.favCarparks.remove(widget.closest[i]);
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text("Remove from favorites"),
                  //   ));
                  // } else {
                  //   widget.favCarparks.add(widget.closest[i]);
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text("Added to favorites"),
                  //   ));
                  // }
                  // // });

                  // print(widget.isSaved);
                  // print(widget.favCarparks);
                },
                icon: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: isSaved ? Colors.red : null,
                ),
              ),
              const Text("Carpark Lots: "),
              Text(
                widget.closest[i][2].toString(),
                textAlign: TextAlign.end,
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getDirections(
      Position currPosition, String destLat, String destLng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${currPosition.latitude},${currPosition.longitude}&destination=$destLat,$destLng&key=$kGoogleApiKey';
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);

    var results = {
      'bounds_ne': json['routes'][0]['bounds']['northeast'],
      'bounds_sw': json['routes'][0]['bounds']['southwest'],
      'start_location': json['routes'][0]['legs'][0]['start_location'],
      'end_location': json['routes'][0]['legs'][0]['end_location'],
      'polyline': json['routes'][0]['overview_polyline']['points'],
      'polyline_decoded': PolylinePoints()
          .decodePolyline(json['routes'][0]['overview_polyline']['points']),
    };
    return results;
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

  //sort accordingly: furthest is furthest from location user selected
  void sortClosest(String dropdownvalue) {
    if (dropdownvalue == items[0]) {
      widget.closest.sort((a, b) => b[2].compareTo(a[2]));
    }
    if (dropdownvalue == items[1]) {
      widget.closest.sort((a, b) => a[2].compareTo(b[2]));
    }
    if (dropdownvalue == items[2]) {
      widget.closest.sort((a, b) => b[5].compareTo(a[5]));
    }
    if (dropdownvalue == items[3]) {
      widget.closest.sort((a, b) => a[5].compareTo(b[5]));
    }
  }

  // Future<Position> locatePosition() async {
  //   // bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

  //   // await Geolocator.checkPermission();
  //   // await Geolocator.requestPermission();

  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   return position;
  //   // LatLng latLngPosition = LatLng(position.latitude, position.longitude);

  //   // Ask permission from device
  //   // Future<void> requestPermission() async {
  //   //   await Permission.location.request();
  //   // }
  // }
}
