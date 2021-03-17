import 'package:flutter/material.dart';
import 'package:news_app/blocs/recent_bloc.dart';
import 'package:news_app/widgets/category_tab_list.dart';
import 'package:news_app/widgets/loading_shimmer.dart';
import 'package:provider/provider.dart';


class Tab6 extends StatefulWidget {
  const Tab6({Key key}) : super(key: key);

  @override
  _Tab6State createState() => _Tab6State();
}

class _Tab6State extends State<Tab6> {

  List data = [];

  @override
  Widget build(BuildContext context) {
    
    final RecentDataBloc rb = Provider.of<RecentDataBloc>(context);
    setState(() {
      data = rb.recentData.where(
        (u) => u['category'].contains('Travel')
      ).toList();
    });
    
    return data.length == 0 
           ? LoadingWidget()
           : categoryTabList(data, 'tab6');
  } 
}
