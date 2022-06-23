import 'package:flutter/material.dart';

class showDirections extends StatelessWidget {
  // const showDirections({Key? key}) : super(key: key);

  final List closest;

  showDirections(this.closest);

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
            children: getDirections(),
          ),
        ),
      ],
    );
  }

  List<Widget> getDirections() {
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
                  child: Text(closest[i][3]),
                ),
              ),
              RaisedButton(
                  color: Colors.white,
                  child: Text("Navigate"),
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)))
            ],
          ),
          Text("Carpark Lots: " + closest[i][2].toString()),
        ],
      ),
    );
  }
}
