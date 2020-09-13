import 'dart:io';

import 'package:app_flutter_avance/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands =[
    Band(id:'1',name: 'Metalica',votes:5),
    Band(id:'2',name: 'Quee',votes:5),
    Band(id:'3',name: 'El gran combo',votes:5),
    Band(id:'4',name: 'Grupo 5',votes:5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diego'),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (_, i) => bandTitle(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }
  addNewBand(){
    final textController = new TextEditingController();
    if(Platform.isAndroid){
     return  showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                child: Text('Add'),
                elevation: 1,
                textColor: Colors.blue,
                onPressed:()=> addBandToList(textController.text),
              ),
            ],
          );
        }
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_){
        return CupertinoAlertDialog(
          title: Text('New band name:'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget> [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: ()=> addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: ()=> Navigator.pop(context),
            )
          ],
        );
      }
    );
  }

  void addBandToList(String name){
    print(name);
    if(name.length > 1){
      this.bands.add(new Band(id: DateTime.now().toString(), name: name,votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }

  Widget bandTitle(Band band) {
    return Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction){
          print('direction: $direction');
        },
        background: Container(
          padding: EdgeInsets.only(left: 8.0),
          color: Colors.red,
          child: Align(
            alignment: Alignment.center,
            child: Text('Delete', style: TextStyle(color: Colors.white),),
          ),
        ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                band.name.substring(0,2)
              ),
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),
            onTap: (){
              print(band.name);
            },
          ),
    );
  }
}