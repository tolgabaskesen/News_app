import 'dart:io';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/bookmark_bloc.dart';
import 'package:news_app/blocs/comments_bloc.dart';
import 'package:news_app/blocs/internet_bloc.dart';
import 'package:news_app/blocs/news_data_bloc.dart';
import 'package:news_app/blocs/notification_bloc.dart';
import 'package:news_app/blocs/popular_bloc.dart';
import 'package:news_app/blocs/recent_bloc.dart';
import 'package:news_app/blocs/recommanded_bloc.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/blocs/user_bloc.dart';
import 'package:news_app/pages/home.dart';
import 'package:news_app/pages/welcome_page.dart';
import 'package:provider/provider.dart';



void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInBloc>(
          create: (context) => SignInBloc(),
        ),
        ChangeNotifierProvider<NewsDataBloc>(
          create: (context) => NewsDataBloc(),
        ),
        ChangeNotifierProvider<PopularDataBloc>(
          create: (context) => PopularDataBloc(),
        ),
        ChangeNotifierProvider<RecentDataBloc>(
          create: (context) => RecentDataBloc(),
        ),
        ChangeNotifierProvider<RecommandedDataBloc>(
          create: (context) => RecommandedDataBloc(),
        ),
        ChangeNotifierProvider<UserBloc>(
          create: (context) => UserBloc(),
        ),
        ChangeNotifierProvider<BookmarkBloc>(
          create: (context) => BookmarkBloc(),
        ),
        ChangeNotifierProvider<CommentsBloc>(
          create: (context) => CommentsBloc(),
        ),
        ChangeNotifierProvider<NotificationBloc>(
          create: (context) => NotificationBloc(),
        ),
        ChangeNotifierProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.white,
          fontFamily: 'Poppins',
          appBarTheme: AppBarTheme(
              
              color: Colors.white,
              brightness:
                  Platform.isAndroid ? Brightness.dark : Brightness.light,
              iconTheme: IconThemeData(color: Colors.black87),
              textTheme: TextTheme(
                headline6: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                  
                )
              )
              ),
        ),
        home: MyHomePage()
      ),
    );
  }
}


class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    return sb.isSignedIn == false ? WelcomePage() : HomePage();
  }
}
