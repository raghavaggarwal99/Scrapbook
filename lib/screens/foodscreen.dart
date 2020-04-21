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
String url1;
String url2;

  void init(){
    getimages();
    super.initState();
  }


  void getimages() async{
      final StorageReference photoreference = FirebaseStorage.instance.ref().child('${overalluserid}');
      photoreference.child('Screenshot_20200409-024054_YouTube.jpg').getDownloadURL().then((data){
        this.setState(() {
         url1=data;
         i++; 
        });
        print(data);
      }).catchError((e){
        print(e);
      });
      photoreference.child('Screenshot_20200410-224919_Instagram.jpg').getDownloadURL().then((data1){
        this.setState(() {
         url2=data1;
         i++; 
        });
        print(data1);
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
    // return Image.memory(imagefile,fit: BoxFit.cover);
     return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
       body: new Center(
        child: new ListView(
          children: [
            Image.network(url1,  
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,),
            Image.network(url2,  
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,),
          ],
          
        ),
       ),
    );
  }


}
