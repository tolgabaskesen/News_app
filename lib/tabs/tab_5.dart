import 'package:flutter/material.dart';
import 'package:news_app/blocs/recent_bloc.dart';
import 'package:news_app/widgets/category_tab_list.dart';
import 'package:news_app/widgets/loading_shimmer.dart';
import 'package:provider/provider.dart';


class Tab5 extends StatefulWidget {
  const Tab5({Key key}) : super(key: key);

  @override
  _Tab5State createState() => _Tab5State();
}

class _Tab5State extends State<Tab5> {

  List data = [];

  @override
  Widget build(BuildContext context) {
    
    final RecentDataBloc rb = Provider.of<RecentDataBloc>(context);
    setState(() {
      data = rb.recentData.where(
        (u) => u['category'].contains('Technology')
      ).toList();
    });
    
    return data.length == 0 
           ? LoadingWidget()
           : categoryTabList(data, 'tab5');
  } 
}
