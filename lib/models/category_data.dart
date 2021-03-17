import 'package:flutter/material.dart';

final List categories = [
  
  'Entertainment',
  'Sports',
  'Politics',
  'Science',
  'Technology',
  'Travel'
  
  
];
/*
  you can change your category here.
  If you change, make sure you have changed in the admin panel.
  Otherwise the app will show error.
*/

/*
  if your change the defalut category, make sure your category item munber is equal to category colors item number.
  Example: If you have 5 categories, then remove an color item in the category colors.
  else if you have more than 6 categories, then you have to add color items in the category colors List down below.
*/

final List categoryColors = [
    Colors.orange[200],
    Colors.blue[200],
    Colors.red[200],
    Colors.pink[200],
    Colors.purple[200],
    Colors.blueGrey[400]
  ];