import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

class FoodScreen extends StatefulWidget {
  @override

  Memories createState() => Memories();
}

class Memories extends State<FoodScreen>{
var overalluserid;
  int maxSize=7*1024*1024;
  Uint8List imagefile;
  Map<int,Uint8List> images={};
  int i=0;

  void getimages() async{
      final StorageReference photoreference = FirebaseStorage.instance.ref().child('${overalluserid}');
      photoreference.getDownloadURL().then((data){
        // this.setState(() {
        //  images[i]=data;
        //  i++; 
        // });
        print(data);
      }).catchError((e){
        print(e);
      });
  }

   @override
  Widget build(BuildContext context) {

     overalluserid = Provider.of<Auth>(
      context,
      listen: false,
    ).userId;
    getimages();
    // return Image.memory(images[0],fit: BoxFit.cover);
     return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: new Container(
        child: new Text("smjfnskjenfks")
      )
    );
  }


}
