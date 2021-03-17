import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news_app/blocs/popular_bloc.dart';
import 'package:news_app/pages/details.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var formKey = GlobalKey<FormState>();
  var textFieldCtrl = TextEditingController();



  @override
  Widget build(BuildContext context) {
    
    final PopularDataBloc pb = Provider.of<PopularDataBloc>(context);

    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          title: Form(
            key: formKey,
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search News',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[800]),
                  onPressed: () {
                    WidgetsBinding.instance.addPostFrameCallback( (_) => textFieldCtrl.clear());
                    pb.afterSearch('');
                  },
                ),
              ),
              
              controller: textFieldCtrl,
              
              onChanged: (String value) {
                pb.afterSearch(value);
              },
            ),
          )),
      body: pb.filteredData.isEmpty
          ? suggestionUI(context)
          : afterSearchUI(context)
    );
  }

  

  Widget suggestionUI(context) {
    PopularDataBloc pb = Provider.of<PopularDataBloc>(context);
    return ListView.separated(
      padding: EdgeInsets.all(15),
      itemCount: pb.popularData.take(5).length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 300),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: InkWell(
          child: Container(
              height: 140,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey[100],
                      blurRadius: 10,
                      offset: Offset(0,3))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Hero(
                      tag: 'suggestion$index',
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 1,
                                  offset: Offset(1, 1))
                            ],
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    pb.popularData[index]['image url']),
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
                              pb.popularData[index]['title'],
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.w500),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                            ),
                          
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.timer,
                                color: Colors.grey,
                                size: 18,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(pb.popularData[index]['date'],
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 12)),
                              Spacer(),
                              Icon(Icons.favorite,
                                  color: Colors.grey, size: 18),
                              SizedBox(
                                width: 2,
                              ),
                              Text(pb.popularData[index]['loves'].toString(),
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
          onTap: () {
            nextScreen(
                context,
                DetailsPage(
                  tag: 'suggestion$index',
                  category: pb.popularData[index]['category'],
                  date: pb.popularData[index]['date'],
                  description: pb.popularData[index]['description'],
                  imageUrl: pb.popularData[index]['image url'],
                  loves: pb.popularData[index]['loves'],
                  timestamp: pb.popularData[index]['timestamp'],
                  title: pb.popularData[index]['title'],
                ));
          },
        ),
                        ),
                      ),
                    );
        
        
        
        
        
      },
    );
  }


  Widget afterSearchUI(context) {
    final PopularDataBloc pb = Provider.of<PopularDataBloc>(context);
    return ListView.separated(
      padding: EdgeInsets.all(15),
      itemCount: pb.filteredData.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 300),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: InkWell(
          child: Container(
              height: 140,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey[100],
                      blurRadius: 10,
                      offset: Offset(0,3))
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Hero(
                      tag: 'filtered$index',
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 1,
                                  offset: Offset(1, 1))
                            ],
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    pb.filteredData[index]['image url']),
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
                              pb.filteredData[index]['title'],
                              style: TextStyle(fontSize: 14, color: Colors.grey[800], fontWeight: FontWeight.w500),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          
                          Spacer(),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.timer,
                                color: Colors.grey,
                                size: 18,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(pb.popularData[index]['date'],
                                  style: TextStyle(
                                      color: Colors.black38, fontSize: 12)),
                              Spacer(),
                              Icon(Icons.favorite,
                                  color: Colors.grey, size: 18),
                              SizedBox(
                                width: 2,
                              ),
                              Text(pb.popularData[index]['loves'].toString(),
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
          onTap: () {
            nextScreen(
                context,
                DetailsPage(
                  tag: 'filtered$index',
                  category: pb.filteredData[index]['category'],
                  date: pb.filteredData[index]['date'],
                  description: pb.filteredData[index]['description'],
                  imageUrl: pb.filteredData[index]['image url'],
                  loves: pb.filteredData[index]['loves'],
                  timestamp: pb.filteredData[index]['timestamp'],
                  title: pb.filteredData[index]['title'],
                ));
          },
        ),
                        ),
                      ),
                    );
        
        
        
        
      },
    );
  }




}
