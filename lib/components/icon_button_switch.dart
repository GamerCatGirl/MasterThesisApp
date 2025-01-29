import 'package:flutter/material.dart';

class IconButtonSwitch extends StatefulWidget {
  final String nameExercise;
  final VoidCallback onTileClicked; // Callback to notify when tile is clicked
  final GlobalKey<IconButtonSwitchState> key;
  final bool visibility;
  final IconData icon;

  const IconButtonSwitch(
      {required this.key,
      required this.nameExercise,
      required this.icon,
      required this.onTileClicked,
      bool this.visibility =
          false}); //, required this.onTileClicked}); //: super(key: key);

  @override
  State<IconButtonSwitch> createState() => IconButtonSwitchState();

  void toggleIconVisibility(bool visibility) {
    key.currentState?.toggleIconVisibility(visibility);
  }
}

class IconButtonSwitchState extends State<IconButtonSwitch> {
  // Boolean to control the icon's visibility
  bool _isIconVisible = false;

  @override
  void initState() {
    super.initState();
    _isIconVisible = widget
        .visibility; // Set initial visibility based on the passed parameter
  }

  // Function to toggle the visibility of the icon
  void toggleIconVisibility(bool visibility) {
    setState(() {
      _isIconVisible = visibility;
    });
  }

  //calculate_outlined icon for simple math ex
  //design_services_outlined  icon for meetkunde

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
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    widget.icon,
                    //Icons.design_services_outlined,
                    size: 40,
                  )),
              /*
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image(
                    width: 50,
                    height: 50,
                    image: AssetImage('assets/images/example_img.jpg')),
              ),
              */
              Container(
                  child: Text(
                widget.nameExercise,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              )),
              Visibility(
                //Icon(IconData(0xf6fc, fontFamily: 'MaterialIcons'),
                child: Icon(Icons.eject,
                    color: Color.fromRGBO(245, 230, 255, 1), size: 40),
                visible: _isIconVisible,
              )
            ],
          ),
        ),
      ),
    );
  }
}
