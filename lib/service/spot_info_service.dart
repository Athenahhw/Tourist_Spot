import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../model/spot.dart';
import '../model/spot_id.dart';
import 'package:http/http.dart' as http;

class SpotInfoService{

  List<Spot> spots =[];


  String getSpotTitle(SpotId id){
    var spot = getSpot(id);
    return spot.title;
  }

  int getCanGoLevel(SpotId id){
    var spot = getSpot(id);
    return spot.canGo;
  }

  Image getImage(SpotId id)
  {
    var spot = getSpot(id);
    String base64ImageString = spot.monitorUrl;
    Uint8List bytes = base64Decode(base64ImageString);
    Image image = Image.memory(bytes);
    return image;
  }

  Spot getSpot(SpotId id)
  {
    if(id == SpotId.spot1)
        return spots[0];
    else if(id == SpotId.spot2)
        return spots[1];
    else if(id == SpotId.spot3)
        return spots[2];
    
    return spots[0];
  }

  Color getCanGoColor(int level) {
    switch(level) {
      case 1:
        return Colors.red;       // 很擁擠
      case 2:
        return Colors.orange;    // 擁擠
      case 3:
        return Colors.yellow;    // 普通
      case 4:
        return Colors.lightGreen;// 較空
      case 5:
        return Colors.green;     // 很空
      default:
        return Colors.grey;      // 不明
    }
  }


  void startTimer()
  {
    Timer.periodic(Duration ( minutes: 1),(_)=>fetchSpots());
  }

  Future<void> fetchSpots() async {

    var url = Uri.parse('https://127.0.0.1:5000/getCanGo');
    var response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: 'accept:application/json',
        }
    );

    if (response.statusCode == 200) {

      var jsonResponse = jsonDecode(response.body);

      List<Spot> newSpots =[];

      for( Map<String,dynamic> spot in jsonResponse)
      {
        Spot currentSpot =
        Spot(title: spot['標題'],
            monitorUrl: spot['及時影像'],
            canGo: spot['canGo']);

        newSpots.add(currentSpot);
      }
      spots = newSpots;

    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  }
}





