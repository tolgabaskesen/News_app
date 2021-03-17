import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:launch_review/launch_review.dart';
import 'package:news_app/blocs/news_data_bloc.dart';
import 'package:news_app/blocs/user_bloc.dart';
import 'package:news_app/models/config.dart';
import 'package:news_app/pages/welcome_page.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  final List titles = [
    'Contact Us',
    'Rate & Review',
    'About App',
    'Full Source Code',
    ];
  final List icons = [
      Icons.email,
      Icons.star_half,
      Icons.nature,
      Icons.code,
    ];
  final List subtitles = [
    Config().email,
    'Rate this app on Google Play',
    'App details',
    'Get source code of app and admin panel'
    
    ];


  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin fbLogin = new FacebookLogin();
  


  handleLogout() async{
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Logout?', style: TextStyle(
            fontWeight: FontWeight.w600
          ),),
          content: Text('Do you really want to Logout?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.pop(context);
                await auth.signOut();
                await googleSignIn.signOut();
                fbLogin.logOut();
                clearAllData();
                nextScreenCloseOthers(context, WelcomePage());

                

              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        );
      }
    );

  }


  void clearAllData () async{
    
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    
  }


  openAboutDialog (){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AboutDialog(
          applicationName: Config().appName,
          applicationIcon: Image(image: AssetImage(Config().splashIcon), height: 30, width: 30,),
        );
      }
    );
  }


  openEmailPopup () async{
    await launch('mailto:${Config().email}?subject=About ${Config().appName} App&body=');

  }

  


  



  @override
  Widget build(BuildContext context) {
  final UserBloc ub = Provider.of<UserBloc>(context);
  final NewsDataBloc nb = Provider.of<NewsDataBloc>(context);
  

  return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            
            
            backgroundColor: Colors.grey[100],
            pinned: true,
            actions: <Widget>[
              
            ],
            
            expandedHeight: 270,
            flexibleSpace: FlexibleSpaceBar(
              
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage: CachedNetworkImageProvider(ub.imageUrl),
                    radius: 45,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(ub.userName, style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  )),
                  Text(ub.email, style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]
                  )),
                  SizedBox(height: 10),
                  FlatButton.icon(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onPressed: ()=> handleLogout(), 
                    icon: Icon(Icons.exit_to_app), 
                    label: Text('Log out'),
                    textColor: Colors.grey[900],
                    
                    
                    ),
                  SizedBox(height: 20,),
                  
                ],
              ),
              
            ),
          ),
         SliverFillRemaining(
           hasScrollBody: true,
           child: Stack(
             children: <Widget>[
               Container(
                  
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(10),
                    itemCount: titles.length,
                    itemBuilder: (BuildContext context, int index) {
                    return Column(
                    
                    children: <Widget>[
                    ListTile(
                    contentPadding: EdgeInsets.only(left: 15,),
                    
                    
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Icon(icons[index], color: Colors.white, size: 25),
                    ),
                    title: Text(titles[index],style: TextStyle(
                      fontSize: 15,
                      
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800]
                    ),),
                    subtitle: Text(subtitles[index],style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45
                    )),

                    onTap: (){
                      if(index == 0){
                          openEmailPopup();
                      } else if(index == 1){
                          LaunchReview.launch(androidAppId: Config().androidPacakageName, iOSAppId: Config().iOSAppId);
                      } else if (index == 2){
                          openAboutDialog();
                      } else if(index == 3){
                          launch(nb.envatoUrl);
                      }
                    },
                    
                    
                  ),
                    
                    ],
                  );
                   },
                  ),
                
              ),

              Align(
                
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40,
                  margin: EdgeInsets.all(20),
                  child: FlatButton.icon(
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    color: Colors.deepPurpleAccent,
                    icon: Icon(Icons.local_grocery_store, color:Colors.white),
                    label: Text('Purchase Now', style: TextStyle(color: Colors.white)),
                    onPressed: ()async{
                      await launch(nb.envatoUrl);
                    },
                  ),
                ),
              )
             ],
           )
         )
         
          
        ],
      ),
    );
  }
}