import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/user_bloc.dart';
import 'package:news_app/pages/profile.dart';
import 'package:news_app/pages/search_page.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final UserBloc ub = Provider.of<UserBloc>(context);

    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 0),
      height: 65,
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        InkWell(
            child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey[400],
            backgroundImage: CachedNetworkImageProvider(ub.imageUrl),
          ),
          onTap: (){
            nextScreen(context, ProfilePage());
          },
        ),
        SizedBox(width: 10,),
        InkWell(

          child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          height: 40,
          width: MediaQuery.of(context).size.width * 0.75,
          alignment: Alignment.centerLeft,
          
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[400], width: 0.5),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
                  'Search News',
                  style: TextStyle(color: Colors.black45, fontSize: 14),
                ),
          ),
      ),
      onTap: (){
        nextScreen(context, SearchPage());
      },
        ),
        ],
      ),
    );
  }
}