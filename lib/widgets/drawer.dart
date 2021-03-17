import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/user_bloc.dart';
import 'package:news_app/pages/bookmark.dart';
import 'package:news_app/pages/category_page.dart';
import 'package:news_app/pages/notification.dart';
import 'package:news_app/pages/profile.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserBloc ub = Provider.of<UserBloc>(context);

    final List titles = ['Categories', 'Bookmark', 'Notifications', 'Profile'];
    final List icons = [
      Icons.category,
      Icons.bookmark_border,
      Icons.notifications_none,
      Icons.verified_user,
      
    ];
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            
            color: Colors.grey[200],
            padding: EdgeInsets.all(15),
            height: 180,
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: <Widget>[
            Flexible(
              flex: 1,
                          child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[400],
              backgroundImage: CachedNetworkImageProvider(ub.imageUrl),
          ),
            ),
            SizedBox(width: 10,),

          Flexible(
            flex: 3,
                      child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(ub.userName, style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),),
                Text(ub.email)
              ],
            ),
          )
              ],
            )          ),
          Container(
            height: 350,
            child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: titles.length,
            itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(titles[index], style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey[700]
              ),),
              leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(icons[index], color: Colors.black87,)),
              onTap: (){
                Navigator.pop(context);
                if(index == 0){
                  nextScreen(context, CategoryPage());
                }
                else if(index == 1){
                  nextScreen(context, BookmarkPage());
                }
                else if(index == 2){
                  nextScreen(context, NotificationPage());
                }
                else if(index == 3){
                  nextScreen(context, ProfilePage());
                }
                
                
              },
            );
           },
          ),
          )
        ],
      ),
    );
  }
}