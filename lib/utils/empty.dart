import 'package:flutter/material.dart';

Widget emptyPage(icon, message) {
  return Center(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.grey[500],
            size: 80,
          ),
          SizedBox(
            height: 10,
          ),
          Text(message, style: TextStyle(color: Colors.grey[500], fontSize: 16), textAlign: TextAlign.center,)
        ],
      
    ),
  );
}
