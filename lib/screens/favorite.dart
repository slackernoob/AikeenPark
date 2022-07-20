import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyFavorites extends StatefulWidget {
  // const MyFavorites({Key? key}) : super(key: key);

  final List favCarparks;

  MyFavorites(this.favCarparks);

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: GoogleFonts.montserrat(
            fontSize: 30,
            color: Colors.white,
          ),
          "Favorite",
        ),
        actions: [
          SizedBox(
            width: 120,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[400],
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                ),
                onPressed: () {
                  setState(() {
                    widget.favCarparks.clear();
                  });
                },
                child: const Text(
                  "Clear Favs",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
        backgroundColor: Colors.brown[400],
      ),
      body: ListView.separated(
          itemCount: widget.favCarparks.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (BuildContext context, int index) {
            List savedFavs = widget.favCarparks[index];
            bool isSaved = widget.favCarparks.contains(savedFavs);

            return ListTile(
              title: Text(widget.favCarparks[index][3]),
              subtitle: Text("Carpark Lots: ${widget.favCarparks[index][2]}"),
              leading: IconButton(
                icon: const Icon(
                  Icons.gps_fixed_sharp,
                  color: Colors.orange,
                ),
                onPressed: () {
                  Navigator.pop(context, widget.favCarparks[index]);
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: (() {
                  setState(() {
                    if (isSaved) {
                      widget.favCarparks.remove(savedFavs);
                    } else {
                      widget.favCarparks.add(savedFavs);
                    }
                  });
                }),
              ),
              onTap: () {},
            );
          }),
    );
  }
}
