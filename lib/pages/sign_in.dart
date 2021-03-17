import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/blocs/internet_bloc.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/models/icons_data.dart';
import 'package:news_app/pages/forgot_password.dart';
import 'package:news_app/pages/sign_up.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/utils/snacbar.dart';
import 'package:provider/provider.dart';






class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  
  var formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  

  
  bool signInStart = false;
  bool signInComplete = false;
  String email;
  String pass;


  
  


  
  

  void lockPressed (){
    if(offsecureText == true){
      setState(() {
        offsecureText = false;
        lockIcon = LockIcon().open;
        
      });
    } else {
      setState(() {
        offsecureText = true;
        lockIcon = LockIcon().lock;

      });
    }
  }
 

  handleSignInwithemailPassword () async{
    final InternetBloc ib = Provider.of<InternetBloc>(context );
    final SignInBloc sb = Provider.of<SignInBloc>(context );
    await ib.checkInternet();
    if (formKey.currentState.validate()){
      formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());

      await ib.checkInternet();
      if(ib.hasInternet == false){
          openSnacbar(_scaffoldKey, 'No internet connection!');
        }else{
          setState(() {
            signInStart = true;
          });
          sb.signInwithEmailPassword(email, pass).then((_)async{
            if(sb.hasError == false){
              
              sb.getUserData(sb.uid)
              .then((value) => sb.saveDataToSP()
              .then((value) => sb.setSignIn()
              .then((value){
                setState(() {
                  signInComplete = true;
                });
                sb.handleAfterSignup(context);
              })));
            } else{
              setState(() {
                signInStart = false;
              });
              openSnacbar(_scaffoldKey, sb.errorCode);
            }
          });
          
        }
    }
  }


  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        
        
        body: signInUI()
      
    );
  }


  




  Widget signInUI () {
    return Form(
            key: formKey,
            child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
            child: ListView(
              children: <Widget>[
                
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  child: IconButton(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.keyboard_backspace), 
                    onPressed: (){
                      Navigator.pop(context);
                    }),
                ),
                Text('Sign In', style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w900
                )),
                Text('Follow the simple steps', style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey
                )),
                SizedBox(
                  height: 80,
                ),
                
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'username@mail.com',
                    //prefixIcon: Icon(Icons.email),
                    labelText: 'Email'
                  
                    
                  ),
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (String value){
                    if (value.length == 0) return "Email can't be empty";
                    return null;
                  },
                  onChanged: (String value){
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(height: 20,),
                
                TextFormField(
                  obscureText: offsecureText,
                  controller: passCtrl,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    //prefixIcon: Icon(Icons.vpn_key),
                    suffixIcon: IconButton(icon: lockIcon, onPressed: (){
                      lockPressed();
                    }),
                    
                    
                  ),
                 

                  validator: (String value){
                    if (value.length == 0) return "Password can't be empty";
                    return null;
                  },
                  onChanged: (String value){
                    setState(() {
                      pass = value;
                    });
                  },
                ),
                
                

                SizedBox(height: 50,),
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    child: Text('Forgot Password?', style: TextStyle(
                      color: Colors.blueAccent
                    ),),
                    onPressed: (){
                      //nextScreen(context, ForgotPasswordPage());
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => ForgotPasswordPage()));
                    }, 

                    
                    ),
                ),

                Container(
                  height: 45,
                  child: RaisedButton(
                        color: Colors.deepPurpleAccent,
                        child: signInStart == false 
                      ? Text('Sign In', style: TextStyle(fontSize: 16, color: Colors.white),)
                      : signInComplete == false 
                      ? CircularProgressIndicator()
                      : Text('Sign In Successful!', style: TextStyle(fontSize: 16, color: Colors.white)),
                        onPressed: (){
                         handleSignInwithemailPassword();
                      }),
                ),
                
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?"),
                    FlatButton(
                      child: Text('Sign Up', style: TextStyle(color: Colors.deepPurpleAccent)),
                      onPressed: (){
                        nextScreenReplace(context, SignUpPage());
                      },
                    )
                  ],
                ),
                SizedBox(height: 50,),
                
              ],
            ),
          ),
        );
  }
}