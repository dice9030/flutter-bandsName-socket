import 'dart:io';

import 'package:app_flutter_avance/models/band.dart';
import 'package:app_flutter_avance/services/socket_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Band> bands =[
    // Band(id:'1',name: 'Metalica',votes:5),
    // Band(id:'2',name: 'Quee',votes:5),
    // Band(id:'3',name: 'El gran combo',votes:5),
    // Band(id:'4',name: 'Grupo 5',votes:5),
  ];

  @override
  void initState() {
    final  socketService = Provider.of<SocketServices>(context,listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload){
    this.bands = (payload as List)
         .map( (band)=>Band.fromMap(band) )
         .toList();
         setState(() {});
  }

  @override
  void dispose() {
    final  socketService = Provider.of<SocketServices>(context,listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final  socketService = Provider.of<SocketServices>(context);    
    return Scaffold(
      appBar: AppBar(
        title: Text('Diego Celis',style: TextStyle(color: Colors.grey),),
        elevation: 1,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ((socketService.serverStatus == ServerStatus.Online ))?  
            Icon(Icons.check_circle,color: Colors.green[300],):Icon(Icons.offline_bolt,color: Colors.red,),
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (_, i) => bandTitle(bands[i]),
          ),)
        ],
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

  Widget _showGraph(){
    Map<String, double> dataMap = new Map();
    bands.forEach((band){
      dataMap.putIfAbsent(band.name,()=> band.votes.toDouble());
    });
    // Map<String, double> dataMap = {
    //   "Flutter": 5,
    //   "React": 3,
    //   "Xamarin": 2,
    //   "Ionic": 2,
    // };

    final List <Color>colorList =[
      Colors.blue[50],
      Colors.blue[100],
      Colors.blue[200],
      Colors.blue[300],
    ];
    return Padding(
      
      padding: const EdgeInsets.all(10.0),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        // chartRadius: MediaQuery.of(context).size.width / 2.2,
        colorList: colorList,
        initialAngleInDegree: 0,
        // chartType: ChartType.ring,
        // ringStrokeWidth: 32,
        // centerText: "HYBRID",
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.left,
          showLegends: true,
          // legendShape: _BoxShape.circle,
          legendTextStyle: TextStyle(
            // fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: true,
          // showChartValuesOutside: true,
          decimalPlaces: 0
        ),
      ),
    );
  }
  void addBandToList(String name){
    if(name.length > 1){
       final  socketService = Provider.of<SocketServices>(context,listen: false);   
       socketService.emit('add-band',{'name':name});
    }
    Navigator.pop(context);
  }

  Widget bandTitle(Band band) {
    final  socketService = Provider.of<SocketServices>(context);    
    return Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) => socketService.emit('delete-band',{'id':band.id}),
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
            onTap: () => socketService.socket.emit('vote-band',{'id':band.id}),            
          ),
    );
  }
}