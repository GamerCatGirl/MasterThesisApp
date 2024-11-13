import 'package:flutter/material.dart';

class TitleTile extends StatelessWidget{
  final String title;

  const TitleTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 35, top: 30),
      //TODO zorg gwn dat de link to veel mogelijk rechts zit maar in marge 
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: 26),
            child: Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
          Text("Alles bekijken", style: TextStyle(color: const Color.fromARGB(255, 17, 110, 186)),)  
            ]
        )
    ); 
  }
}