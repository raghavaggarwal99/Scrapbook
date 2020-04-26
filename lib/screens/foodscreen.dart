import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      var imagesfilename = new List<String>();
       var urls = new List<String>();
       var description = new List<String>();

  // void init(){
  //   getimages();
  //   super.initState();
  // }


  void getimages() async{
      print("entred");
       

      final db = Firestore.instance;

        db
        .collection("Scrapbook")
        .document(overalluserid)
        .collection("Images")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) 
          {
            // print("sdvs")
            imagesfilename.add(f.data["Image_Name"].toString());
            description.add(f.data["description"].toString());
             final StorageReference photoreference = FirebaseStorage.instance.ref().child('${overalluserid}');
              photoreference.child(f.data["Image_Name"].toString()).getDownloadURL().then((data){
                this.setState(() { 
                   urls.add(data);
                   print(urls[0]);
                });
              }).catchError((e){
                print(e);
              });
            }
          );
    });

  }

   @override
  Widget build(BuildContext context) {

     overalluserid = Provider.of<Auth>(
      context,
      listen: false,
    ).userId;
    getimages();
    // return Image.memory(imagefile,fit: BoxFit.cover);
     return Scaffold(

      backgroundColor: Theme.of(context).primaryColor,
       body: new Center(
        child: new ListView(
          children: [
            //Yaha loop laga de if url is empty toh kuch nahi.
            Image.network(urls[0],  
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,),
          ],
          
        ),
        // child:new Text(urls[0])
       ),
    );
  }


}
