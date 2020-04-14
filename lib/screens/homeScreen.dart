import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../providers/auth.dart';
// import './view_images.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/take-pic';

  @override
  _TakePicScreenState createState() => _TakePicScreenState();
}



class _TakePicScreenState extends State<HomeScreen> {
  File _takenImage;
  var overalluserid;
  File _cameraImage;

   Future<void> imageSelectorCamera() async {
    var cameraphoto = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _cameraImage = cameraphoto;    
    });

    print(_cameraImage);

    String fileName = basename(_cameraImage.path);
    print(fileName);
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('${overalluserid}/${fileName}');
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_cameraImage);
       StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
       print(taskSnapshot);
       setState(() {
          print("Camera Picture uploaded");
          // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });

  }



  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _takenImage = imageFile;
    });

    print(_takenImage);
    
    // uploadPic(context);
    //  Provider.of<Pictures>(context, listen: false).storeImage(_imageToStore)

    // _storeImage();
    String fileName = basename(_takenImage.path);
    print(fileName);
       StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('${overalluserid}/${fileName}');
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_takenImage);
       StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
       print(taskSnapshot);
       setState(() {
          print("Profile Picture uploaded");
          // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });
   
  }

  @override
  Widget build(BuildContext context) {
     overalluserid = Provider.of<Auth>(
      context,
      listen: false,
    ).userId;

    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  _displayOptionsDialog(context);
                },
                child: Text('Click Me'),
              )
            ],
          ),
        ));
  }

  void _displayOptionsDialog(context) async {
    await _optionsDialogBox(context);
  }

  Future<void> _optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take Photo'),
                    onTap: imageSelectorCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select Image From Gallery'),
                    onTap: _takePicture,
                  ),
                ],
              ),
            ),
          );
        });
  }





}
