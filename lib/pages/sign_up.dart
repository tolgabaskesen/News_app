import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/blocs/internet_bloc.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/models/icons_data.dart';
import 'package:news_app/pages/sign_in.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/utils/snacbar.dart';
import 'package:provider/provider.dart';



class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var nameCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  



  
  String email;
  String pass;
  String name;
  bool signUpStarted = false;
  bool signUpCompleted = false;
  


  
  

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



  Future handleSignUpwithEmailPassword () async{
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
            signUpStarted = true;
          });
          sb.signUpwithEmailPassword(name, email, pass).then((_)async{
            if(sb.hasError == false){
              sb.getTimestamp()
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.saveToFirebase()
            .then((value) => sb.setSignIn()
            .then((value){
              setState(() {
                signUpCompleted = true;
              });
              sb.handleAfterSignup(context);
            }))));
            } else{
              setState(() {
                signUpStarted = false;
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
        body: signUpUI()
      
    );
  }



  Widget signUpUI () {
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
                Text('Sign Up', style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.w900
                )),
                Text('Follow the simple steps', style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey
                )),
                SizedBox(
                  height: 60,
                ),
                
                
                TextFormField(
                  controller: nameCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter Name',
                    //prefixIcon: Icon(Icons.person)
                  ),
                  validator: (String value){
                    if (value.length == 0) return "Name can't be empty";
                    return null;
                  },
                  onChanged: (String value){
                    setState(() {
                      name = value;
                    });
                  },
                ),

                SizedBox(height: 20,),

                
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'username@mail.com',
                    labelText: 'Email Address',
                    //prefixIcon: Icon(Icons.email)
                  
                    
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
                  controller: passCtrl,
                  obscureText: offsecureText,
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
                  height: 45,
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.deepPurpleAccent,
                    child: signUpStarted == false 
                      ? Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white),)
                      : signUpCompleted == false 
                      ? CircularProgressIndicator()
                      : Text('Sign Up Successful!', style: TextStyle(fontSize: 16, color: Colors.white)),
                    onPressed: (){
                     handleSignUpwithEmailPassword();
                  }),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Already have an account?'),
                    FlatButton(
                      child: Text('Sign In', style: TextStyle(color: Colors.deepPurpleAccent),),
                      onPressed: (){
                        nextScreenReplace(context, SignInPage());
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