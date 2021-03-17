import 'package:flutter/material.dart';
import 'package:news_app/widgets/featured.dart';
import 'package:news_app/widgets/popular_news.dart';
import 'package:news_app/widgets/recent_news.dart';
import 'package:news_app/widgets/recommanded_news.dart';
import 'package:news_app/widgets/search_bar.dart';

class Tab0 extends StatefulWidget {
  Tab0({Key key}) : super(key: key);

  @override
  _Tab0State createState() => _Tab0State();
  }

  class _Tab0State extends State<Tab0> {

  
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        
        SearchBar(),
        
        Featured(),
        Popular(),
        Recent(),
        Recommanded(),
      ],
    );
  }
}