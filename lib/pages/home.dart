import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 5),
    Band(id: '3', name: 'Boanerges', votes: 5),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 1,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => _bandTile(bands[index]),
        itemCount: bands.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(left: 8.0),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white,)),
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0, 2)),
            ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: TextStyle(fontSize: 20),),
        onTap: (){
              print(band.name);
        },
          ),
      onDismissed: (direction){

      },
    );
  }
  addNewBand(){
    final textController = TextEditingController();
    /*if(Platform.isAndroid){
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: const Text('New bandName'),
          content: TextField(controller: textController,),
          actions: [
            MaterialButton(
              onPressed: ()=> addBandToList(textController.text),
              elevation: 5,
              textColor: Colors.blue,
              child: const Text('Add'),)],
        );
      });
    }else{*/
      showCupertinoDialog(context: context, builder: (_){
        return CupertinoAlertDialog(
          title: const Text('New bandName'),
          content: CupertinoTextField(controller: textController,),
          actions: [
            CupertinoDialogAction(
              onPressed: ()=> addBandToList(textController.text),
              isDefaultAction: true,
              child: const Text('Add'),),
            CupertinoDialogAction(
              onPressed: ()=> Navigator.pop(context),
              isDestructiveAction: true,
              child: const Text('Dismiss'),),
          ],
        );
      });
    //}

  }
  addBandToList(String name){
    if(name.length>1){
      this.bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {
      });
    }
    Navigator.pop(context);
  }
}