import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TextExerciseEdit extends StatefulWidget {
  const TextExerciseEdit({super.key});

  @override
  State<TextExerciseEdit> createState() => _TextExerciseEditState();
}

class _TextExerciseEditState extends State<TextExerciseEdit> {
  List<Widget> toShow = [];
  List<TextEditingController> controllers = [];

  Widget newTextfield() {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          border: OutlineInputBorder(), hintText: 'Enter your text *'),
    );
  }

  Widget newTitle() {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          border: OutlineInputBorder(), hintText: 'Enter your subtitle'),
    );
  }

  Widget newImage() {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          border: OutlineInputBorder(), hintText: 'Enter link to image'),
    );
  }

  Widget newLink() {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
          border: OutlineInputBorder(), hintText: 'Enter link to webpage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textField = newTextfield();
    final TextEditingController topicController = TextEditingController();
    if (controllers.isEmpty) {
      controllers.add(topicController);
    }

    var topic = TextFormField(
      controller: topicController,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Enter the topic name *',
      ),
    );
    var subTitle = newTitle();

    var saveButton = Center(
      child: ElevatedButton(
        child: Text("Save"),
        style: ElevatedButton.styleFrom(
          elevation: 3,
        ),
        onPressed: () {
          //TODO: post to database
          print(topicController.text);
        },
      ),
    );

    var icons = Row(
      children: [
        IconButton(
          icon: Icon(Icons.text_snippet_outlined), //add text field
          onPressed: () {
            setState(() {
              toShow.add(newTextfield());
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.text_increase_outlined), //add title field
          onPressed: () {
            setState(() {
              toShow.add(newTitle());
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.add_photo_alternate_outlined), //add image field
          onPressed: () {
            setState(() {
              toShow.add(newImage());
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.add_link_outlined), //add link to certain webpage
          onPressed: () {
            setState(() {
              toShow.add(newLink());
            });
          },
        ),
        // TODO: add button to add subtitle
      ],
    );

    if (toShow.length == 0) {
      toShow = [topic, icons, subTitle, textField];
    }

    // TODO: implement build
    return Positioned(
      left: 10,
      right: 10,
      top: 126,
      child: Container(
        width: 150,
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
              child: Column(children: [Column(children: toShow), saveButton]),
            ),
            //TODO: on the image add the duration of exercise
          ],
        ),
        decoration: BoxDecoration(
            color: Color.fromRGBO(245, 230, 255, 1),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
