import 'package:aikeen_park/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';

class showDirections extends StatefulWidget {
  // const showDirections({Key? key}) : super(key: key);

  final List closest;
  final Function go_to_place;
  final Function set_Polyline;
  final int polylineIdCounter;
  final Set<Polyline> _polylines;

  showDirections(this.closest, this.go_to_place, this.set_Polyline,
      this.polylineIdCounter, this._polylines);

  @override
  State<showDirections> createState() => _showDirectionsState();
}

class _showDirectionsState extends State<showDirections> {
  late Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Card(
          child: Text(
            "DIRECTIONS",
            style: TextStyle(fontSize: 15),
          ),
          color: Colors.grey,
          margin: EdgeInsets.only(top: 10),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView(
            padding: EdgeInsets.only(top: 10),
            children: createDirections(),
          ),
        ),
      ],
    );
  }

  List<Widget> createDirections() {
    List<Widget> directionCards = [];
    for (int i = 0; i < 5; i++) {
      directionCards.add(directionCard(i));
    }
    return directionCards;
  }

  Widget directionCard(int i) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Colors.red,
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(widget.closest[i][3]),
                ),
              ),
              RaisedButton(
                  color: Colors.white,
                  child: Text("Navigate"),
                  onPressed: () async {
                    widget._polylines.clear();
                    _getCurrentLocation();

                    var directions = await getDirections(
                      _currentPosition.latitude.toString(),
                      _currentPosition.longitude.toString(),
                      widget.closest[i][0].toString(),
                      widget.closest[i][1].toString(),
                    );
                    widget.set_Polyline(directions['polyline_decoded']);
                    widget.go_to_place(
                      directions['start_location']['lat'],
                      directions['start_location']['lng'],
                      directions['bounds_ne'],
                      directions['bounds_sw'],
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)))
            ],
          ),
          Text("Carpark Lots: " + widget.closest[i][2].toString()),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> getDirections(
      String currLat, String currLng, String destLat, String destLng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=' +
            currLat +
            ',' +
            currLng +
            '&destination=' +
            destLat +
            ',' +
            destLng +
            '&key=' +
            kGoogleApiKey;
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

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}
