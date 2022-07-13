import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({Key? key}) : super(key: key);

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  final titles = ["Carpark 1", "Carpark 2", "Carpark 3"];
  final subtitles = [
    "Carpark Lots",
    "Carpark Lots",
    "Carpark Lots",
  ];
  final icons = [Icons.favorite, Icons.favorite_border, Icons.favorite];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: GoogleFonts.montserrat(
            fontSize: 30,
            color: Colors.white,
          ),
          "Favorite Carparks",
        ),
        backgroundColor: Colors.brown[400],
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  title: Text(titles[index]),
                  subtitle: Text(subtitles[index]),
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                  trailing: Icon(icons[index])));
        },
      ),
    );
  }
}
