import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionPage extends StatefulWidget {
  int typeValue;
  int numValue;

  OptionPage(this.typeValue, this.numValue);

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          style: GoogleFonts.montserrat(
            fontSize: 30,
            color: Colors.white,
          ),
          "Options",
        ),
        backgroundColor: Colors.brown[400],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Carpark Type: ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            radioRow(1, widget.typeValue, "Cars", setType),
            radioRow(2, widget.typeValue, "Heavy Vehicles", setType),
            radioRow(3, widget.typeValue, "Motorcycles", setType),
            const SizedBox(height: 30.0),
            const Text(
              "Choose the number of carparks displayed: ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            radioRow(1, widget.numValue, "5", setNum),
            radioRow(2, widget.numValue, "10", setNum),
            radioRow(3, widget.numValue, "15", setNum),
            radioRow(4, widget.numValue, "20", setNum),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(
                      context, [widget.typeValue, widget.numValue]),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown[400],
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                  child: const Text("Finish Selecting"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget radioRow(int custValue, int custGroupValue, String custString,
      Function setValues) {
    return Row(
      children: [
        Radio(
            activeColor: Colors.brown,
            value: custValue,
            groupValue: custGroupValue,
            onChanged: (value) => setValues(value)),
        const SizedBox(width: 10.0),
        Text(
          custString,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  void setType(value) {
    setState(() {
      widget.typeValue = value as int;
    });
  }

  void setNum(value) {
    setState(() {
      widget.numValue = value as int;
    });
  }
}
