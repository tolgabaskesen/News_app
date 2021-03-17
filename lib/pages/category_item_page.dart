

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/recent_bloc.dart';
import 'package:news_app/pages/details.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';

class CategoryItemPage extends StatefulWidget {
  final String category;
  final String tag;
  final Color color;
  CategoryItemPage({Key key,@required this.category, this.tag, this.color}) : super(key: key);

  @override
  _CategoryItemPageState createState() => _CategoryItemPageState(this.category, this.tag, this.color);
}

class _CategoryItemPageState extends State<CategoryItemPage> {

  final String category;
  final String tag;
  final Color color;
  _CategoryItemPageState(this.category, this.tag, this.color);

  List data = [];



  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    final RecentDataBloc rb = Provider.of<RecentDataBloc>(context);
    setState(() {
      data = rb.recentData.where(
        (u) => u['category'].contains(category)
      ).toList();
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.keyboard_backspace,color: Colors.white,),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
            backgroundColor: color,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              background: Hero(
                tag: tag,
                child: Container(
                  color: color,
                height: 120,
                width: double.infinity,
              ),
              ),
              
              title: Text(category, 
              style: TextStyle(
                fontWeight: FontWeight.w500
              ),
              ),
              titlePadding: EdgeInsets.only(left: 20,bottom: 10 ),
              
            ),
          ),
          SliverList(
            
            delegate: SliverChildBuilderDelegate(
              
              (context, index){
              return index.isOdd
            ? InkWell(
                child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
                    height: 240,
                    width: w,
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
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 5,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    data[index]['title'],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[800], fontWeight: FontWeight.w500),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      data[index]['description'],
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Hero(
                                tag: 'tab2$index',
                                child: Container(
                                  height: 100,
                                  width: 100,
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
                            )
                          ],
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
                              width: 3,
                            ),
                            Text(data[index]['date'], style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13
                            ),),
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
                                      color: Colors.black38, fontSize: 14)),
                          ],
                        )
                      ],
                    )),
                onTap: () {
                  
                  nextScreen(
                      context,
                      DetailsPage(
                        tag: 'tab2$index',
                        category: data[index]['category'],
                        date: data[index]['date'],
                        description: data[index]['description'],
                        imageUrl: data[index]['image url'],
                        loves: data[index]['loves'],
                        timestamp: data[index]['timestamp'],
                        title: data[index]['title'],
                      ));
                },
              )
            : InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 5),
                  height: 365,
                  width: w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 10,
                            offset: Offset(3, 3))
                      ]),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'tab2$index',
                        child: Container(
                          height: 200,
                          width: w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(data[index]['image url']),
                                  fit: BoxFit.cover)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 6, bottom: 6),
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.deepPurpleAccent.withOpacity(0.7)),
                                child: Text(
                                 data[index]['category'], style: TextStyle(
                                   fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white
                                 ),
                                ), ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                data[index]['title'],
                                style: 
                                    TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[800]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                data[index]['description'],
                                style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),

                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            
                            SizedBox(
                              height: 20,
                            ),
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
                                  style: TextStyle(color: Colors.grey[600],
                                  fontSize: 13
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
                      )
                    ],
                  ),
                ),
                onTap: () {
                  nextScreen(
                      context,
                      DetailsPage(
                        tag: 'tab2$index',
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