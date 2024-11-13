import 'package:flutter/material.dart';

class TypeExerciseTile extends StatefulWidget{
  final String nameExercise;
  final VoidCallback onTileClicked; // Callback to notify when tile is clicked
  final GlobalKey<TypeExerciseTileState> key;
  final bool visibility; 

  const TypeExerciseTile({required this.key, required this.nameExercise, required this.onTileClicked, bool this.visibility = false}); //, required this.onTileClicked}); //: super(key: key);

  @override
  State<TypeExerciseTile> createState() => TypeExerciseTileState();

  void toggleIconVisibility(bool visibility) {
    key.currentState?.toggleIconVisibility(visibility);
  }
}

class TypeExerciseTileState extends State<TypeExerciseTile> {
  // Boolean to control the icon's visibility
  bool _isIconVisible = false;

   @override
  void initState() {
    super.initState();
    _isIconVisible = widget.visibility; // Set initial visibility based on the passed parameter
  }

  // Function to toggle the visibility of the icon
  void toggleIconVisibility(bool visibility) {
    setState(() {
      _isIconVisible = visibility;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
      onTap: () {
        widget.onTileClicked();
      },
      child: Container(
        child: Column(
          children: [
              //TODO: on the image add the duration of exercise
              //TODO: add the type of exercise
              //TODO: add the dificulty level 
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                width: 50,
                height: 50,
                image: AssetImage('assets/images/example_img.jpg')),
            ),
            Container(
              child: Text(
                widget.nameExercise,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
              )
              ),
            Visibility(
              child: Icon( IconData(0xf6fc, fontFamily: 'MaterialIcons'),
                            color: Color.fromRGBO(245, 230, 255, 1),
                            size: 40),
              visible: _isIconVisible,
            )  
          ],
          
        ),
      ),
    ),
    );
  }
}