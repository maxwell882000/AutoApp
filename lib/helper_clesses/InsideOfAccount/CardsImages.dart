import 'dart:convert';
import 'dart:typed_data';



import 'package:flutter/material.dart';
import 'package:flutter_projects/Singleton/SingletonConnection.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';

import '../LoadingScreen.dart';

class CardsImages extends StatefulWidget {
  final int unique;
  final String path;
 final Function delete;
 final Widget child;
 CardsImages({Key key,this.path,this.delete,this.child,this.unique}):super(key: key);
  @override
  _CardsImagesState createState() => _CardsImagesState(
    path:path,
    delete:delete,
    child:child,
    unique:unique,
  );
}

class _CardsImagesState extends State<CardsImages> {
  final String path;
  bool pressed = false;
  final Function delete;
  final Widget child;
  bool uploaded = false;
  int id;
  final int unique;
  Uint8List image;
  Widget swaps;
  _CardsImagesState({this.path,this.delete,this.child,this.unique});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    swaps = child;
    print(path);
    if (path !=null) {
      SingletonConnection().sendImage(path).then((value) {
        if(mounted){
        setState(() {
          value.stream.bytesToString().then((value) {
            uploaded = true;
            id = jsonDecode(value)['id'];
            if(id>0)
            SingletonUserInformation().newCard.attach.uploadedImage.add(id);
          });
        });
        }
      });
    }
    else{
      SingletonConnection().downloadImage(unique).then((value) {
        if (mounted) {
          setState(() {
            image = value.bodyBytes;
            id = unique;
            swaps = Image.memory(image, fit: BoxFit.fill,);
            uploaded = true;
          });
        }
      }
      );

    }
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      key: UniqueKey(),
      onLongPress: () {
        if (uploaded == true) {
          setState(() {
            pressed = true;
          });
          if(delete !=null)
             delete(id);
          print("DELETE ID : $id");
          SingletonUserInformation().newCard.attach.image.remove(id);
          SingletonConnection().deleteImage(id);

        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1000),
        width: pressed?0:width*0.3,
        height: pressed?0:width*0.3,
        margin: EdgeInsets.symmetric(horizontal: width*0.05),
        child: !uploaded? Center(
          child: LoadingScreen(
            visible: true,
            color: "F0F8FF",
            size: width*0.2,
          ),
        ):swaps,

      ),
    );
  }
}
