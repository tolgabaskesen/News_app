import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:news_app/blocs/popular_bloc.dart';
import 'package:news_app/blocs/recent_bloc.dart';
import 'package:news_app/pages/details.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';


class MoreNewsPage extends StatefulWidget {
  final String title;
  MoreNewsPage({Key key,@required this.title}) : super(key: key);

  @override
  _MoreNewsPageState createState() => _MoreNewsPageState(this.title);
}

class _MoreNewsPageState extends State<MoreNewsPage> {

  String title;
  _MoreNewsPageState(this.title);

  List data = [];


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0)).then((_){
      final PopularDataBloc pb = Provider.of<PopularDataBloc>(context);
      final RecentDataBloc rb = Provider.of<RecentDataBloc>(context);
      if(title == 'Popular'){
        pb.getData();
        setState(() {
          data = pb.popularData;
        });
      }
      else{
        rb.getData();
        setState(() {
          data = rb.recentData;
        });
      }
      
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.close,color: Colors.white,),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
            backgroundColor: Colors.blueGrey[800],
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              background: Container(
                color: Colors.blueGrey[800],
                height: 120,
                width: double.infinity,
              ),
              
              
              title: Text('$title News', 
              
              ),
              titlePadding: EdgeInsets.only(left: 20,bottom: 10 ),
              
            ),
          ),
          SliverList(
            
            delegate: SliverChildBuilderDelegate(
              
              (context, index){
              return InkWell(
                          child: Container(
                          margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 0),
                          height: 170,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey[300],
                                    blurRadius: 10,
                                    offset: Offset(3, 3))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child: Hero(
                                    tag: 'MoreNews$index',
                                    child: Container(
                                    height: 140,
                                    width: 140,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey[200],
                                              blurRadius: 1,
                                              offset: Offset(1, 1))
                                        ],
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(data[index]['image url']),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          data[index]['title'],
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.w500),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      
                                      Spacer(),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, top: 3, bottom: 3),
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: Colors.black12),
                                        child: Text(
                                          data[index]['category'],
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  data[index]['date'],
                                  style: TextStyle(color: Colors.grey[500],
                                  fontSize: 12
                                  ),
                                  
                                ),
                                Spacer(),
                                Icon(
                                Icons.favorite,
                                color: Colors.grey,
                                size: 20,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(data[index]['loves'].toString(),
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 13)),
                              ],
                            )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
      
                          onTap: (){
                            nextScreen(
                            context,
                            DetailsPage(
                              tag: 'MoreNews$index',
                              category: data[index]['category'],
                              
                              date: data[index]['date'],
                              description: data[index]['description'],
                              imageUrl: data[index]['image url'],
                              loves: data[index]['loves'],
                              timestamp: data[index]['timestamp'],
                              title: data[index]['title'],
                            ));
                          },
                    );

            },

            childCount: data.length,


            
            ),
          )
          
        ],
      ),
    );
    
  }
}