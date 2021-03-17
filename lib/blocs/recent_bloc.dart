import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class RecentDataBloc extends ChangeNotifier {
  
  List _recentData = [];
  List get recentData => _recentData;

  
  

  RecentDataBloc(){
    getData();
  }


  Future getData() async {
    QuerySnapshot snap = await Firestore.instance.collection('contents').getDocuments();
    var x = snap.documents;
    _recentData.clear();
    x.forEach((f) {
      _recentData.add(f);
    });
    _recentData.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
    notifyListeners();
    

    
  }
}
