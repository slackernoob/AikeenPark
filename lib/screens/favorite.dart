import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFavorites extends StatefulWidget {
  // const MyFavorites({Key? key}) : super(key: key);

  final List favCarparks;
  final List closest;

  MyFavorites(this.favCarparks, this.closest);

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
          IconButton(
            onPressed: () {
              print(widget.favCarparks);
              print("___");
              print(widget.favCarparks.length);
              print("________");
              print(widget.closest);
            },
            icon: const Icon(Icons.check),
          ),
        ],
        backgroundColor: Colors.brown[400],
      ),
      body: ListView.separated(
          itemCount: widget.closest.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (BuildContext context, int index) {
            List savedFavs = widget.closest[index];
            bool isSaved = widget.favCarparks.contains(savedFavs);

            return ListTile(
              title: Text(widget.closest[index][3]),
              subtitle: Text("Carpark Lots: ${widget.closest[index][2]}"),
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
              trailing: Icon(
                isSaved ? Icons.favorite : Icons.favorite_border,
                color: isSaved ? Colors.red : null,
              ),
              onTap: () {
                setState(() {
                  if (isSaved) {
                    widget.favCarparks.remove(savedFavs);
                  } else {
                    widget.favCarparks.add(savedFavs);
                  }
                });
              },
            );
          }),
    );
  }
}


//right now only can clear from below
//trying to implement ontap change icon only 
//mayb everytime clcik from list showtoast 'added' / 'remove