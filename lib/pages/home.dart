import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';
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
  void initState(){
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands',_hadleActiveBands);
    super.initState();
  }
  _hadleActiveBands(dynamic data){
    bands=[];
    bands=(data as List).map((band)=> Band.fromMap(band)).toList();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 1,
        actions: [
          Container(
            margin:const EdgeInsets.only(right: 10),
            child: Icon(socketService.serverStatus==ServerStatus.online? Icons.signal_cellular_4_bar:Icons.signal_cellular_connected_no_internet_0_bar, color: socketService.serverStatus==ServerStatus.online? Colors.lightGreenAccent: Colors.deepOrangeAccent, ),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(child:  ListView.builder(
            itemBuilder: (context, index) => _bandTile(bands[index]),
            itemCount: bands.length,
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
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
              socketService.emit('vote-band',band.id);
        },
          ),
      onDismissed: (direction){
        socketService.emit('delete-band',band.id);
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    if(name.length>1){
      socketService.emit('new-band',name);
    }
    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = {};
    bands.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });
    return Container(
      width: double.infinity,
        height: 300,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3.2,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 32,
          centerText: "BANDAS",
          legendOptions:const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendShape: BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions:const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: true,
            decimalPlaces: 0,
          ),
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        )
    );
  }
}
