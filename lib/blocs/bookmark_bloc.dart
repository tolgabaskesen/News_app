import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkBloc extends ChangeNotifier {

  List _data = [];
  List get data => _data;
  

  

  void getData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String _uid = sp.getString('uid');

    final DocumentReference ref = Firestore.instance.collection('users').document(_uid);
    DocumentSnapshot snap = await ref.get();
    List d = snap.data['bookmarked items'];
    _data.clear();

    Firestore.instance
        .collection('contents')
        .getDocuments()
        .then((QuerySnapshot snap) {
      var x = snap.documents;
      for (var item in x) {
        if (d.contains(item['timestamp'])) {
          _data.add(item);
        }
      }
      notifyListeners();
    });
  
  }
}
