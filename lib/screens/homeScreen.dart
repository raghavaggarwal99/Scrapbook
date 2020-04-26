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
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/take-pic';

  @override
  _TakePicScreenState createState() => _TakePicScreenState();
}



class _TakePicScreenState extends State<HomeScreen> {
   final _formKey = new GlobalKey<FormState>();
  int check=0;
  var overalluserid;
  File _takenImage;
  var description;
  final db = Firestore.instance;
  String fileName;

  void validateAndSubmit() async{

     final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
       print("yes the form is validated");
      print(description);
      print(fileName);

      if(fileName!=null && description!=null ){
        await db.collection('Scrapbook').document(overalluserid).collection("Images").add({
            'Image_Name': fileName,
            'Description': description,
            });

        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('${overalluserid}/${fileName}');
       StorageUploadTask uploadTask = firebaseStorageRef.putFile(_takenImage);
       StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
       print(taskSnapshot);
       setState(() {
          print("Picture uploaded!!!");
          // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
       });
        
      }
      else{
        print("Some field is empty");
      }
    }
   
  }

   Future<void> imageSelectorCamera() async {
    // File _cameraImage;
    var cameraphoto = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (this.mounted){
      setState(() {
        _takenImage = cameraphoto;    
      });
    }

    print(_takenImage);

     fileName = basename(_takenImage.path);
    print(fileName);
  

  }



  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile == null) {
      return;
    }
    if (this.mounted){
      setState(() {
        _takenImage = imageFile;
      });
    }
    print(_takenImage);
    
  
     fileName = basename(_takenImage.path);
    print(fileName);
    
      //  StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('${overalluserid}/${fileName}');
      //  StorageUploadTask uploadTask = firebaseStorageRef.putFile(_takenImage);
      //  StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
      //  print(taskSnapshot);
      //  setState(() {
      //     print("Profile Picture uploaded");
      //     // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      //  });
   
  }

  @override
  Widget build(BuildContext context) {
     overalluserid = Provider.of<Auth>(
      context,
      listen: false,
    ).userId;

    return Scaffold(
       body: Stack(
          children: <Widget>[
            // showImageButton(context),
            _showForm(context),
          ],
        )
        );
  }

    Widget _showForm(context) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              // showLogo(),
              showImageButton(context),
              showDescriptionInput(),
              showPrimaryButton(),
              
            ],
          ),
        ));
  }


  Widget showImageButton(context){
    return RaisedButton(
        onPressed: () {
           _displayOptionsDialog(context);
          },
        child: Text('Click Me'),
      );
  }


    Widget showDescriptionInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Description',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) {
          if(value.isEmpty){
            return "Description should not be empty";
          }
          else{
            return null;
          }
        },
        onSaved: (value) => description = value.trim(),
      ),
    );
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

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Submit',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
            //Here what i did was I summed up the signup and sign in in this fucntion only. So when I click the "Create an account" It's just a bool _isLoginForm 
          ),
        ));
  }




}
