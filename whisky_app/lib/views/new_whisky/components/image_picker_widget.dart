import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  File image;

  Future getImage() async {
    File picture = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      image = picture;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image == null
                ? Container()
                : Material(
                    borderRadius: BorderRadius.circular(4.0),
                    elevation: 2.0,
                    child: Image.file(
                      image,
                      fit: BoxFit.cover,
                      height: 180.0,
                      width: 100.0,
                    ),
                  ),
            image == null
                ? Container()
                : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(image),
                        )),
                  ),
          ],
        ),
        FloatingActionButton(
          onPressed: getImage,
          backgroundColor: theme.accentColor,
          tooltip: 'Take a picture',
          child: Icon(Icons.add_a_photo),
          elevation: 2.0,
        ),
      ],
    );
  }
}
