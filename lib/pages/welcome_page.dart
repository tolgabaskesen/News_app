import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/blocs/internet_bloc.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/models/config.dart';
import 'package:news_app/pages/intro.dart';
import 'package:news_app/pages/sign_up.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/utils/toast.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {


  bool signInStartGoogle = false;
  double leftPaddingGoogle = 20;
  double rightPaddingGoogle = 20;
  bool signInCompleteGoogle = false;


  bool signInStartFb = false;
  double leftPaddingFb = 10;
  double rightPaddingFb = 10;
  bool signInCompleteFb = false;
  



  handleGoogleSignIn() async{
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    await ib.checkInternet();
    if(ib.hasInternet == false){
      openToast1(context, 'Check your internet connection');
      
    }else{
      
      handleAnimationGoogle();
      await sb.signInWithGoogle().then((_){
        if(sb.hasError == true){
          openToast1(context, 'Something is wrong. Please try again.');
          setState(() {signInStartGoogle = false;});
          handleReverseAnimationGoogle();

        }else {
          sb.checkUserExists().then((value){
          if(sb.userExists == true){
            sb.getUserData(sb.uid)
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.setSignIn()
            .then((value){
              setState(()=> signInCompleteGoogle = true);
              handleAfterSignupGoogle();
            })));
          } else{
            sb.getTimestamp()
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.saveToFirebase()
            .then((value) => sb.setSignIn()
            .then((value){
              setState(()=> signInCompleteGoogle = true);
              handleAfterSignupGoogle();
            }))));
          }
            });
          
        }
      });
    }
  }



  void handleFacebbokLogin () async{
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    final InternetBloc ib = Provider.of<InternetBloc>(context);
    await ib.checkInternet();
    if(ib.hasInternet == false){
      openToast1(context, 'Check your internet connection');
    }else{
      handleAnimationFb();
      await sb.logInwithFacebook().then((_){
        
        if(sb.hasError == true){
          openToast1(context, 'Error with facebook login! Please try with google');
          setState(() {signInStartFb = false;});
          handleReverseAnimationFb();
          
        }else {
          
          sb.checkUserExists().then((value){
          if(sb.userExists == true){
            sb.getUserData(sb.uid)
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.setSignIn()
            .then((value){
              setState(()=> signInCompleteFb = true);
              handleAfterSignupFb();
            })));
          } else{
            sb.getTimestamp()
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.saveToFirebase()
            .then((value) => sb.setSignIn()
            .then((value){
              setState(()=> signInCompleteFb = true);
              handleAfterSignupFb();
            }))));
          }
            });
          
        }
      });
      
    }
  }



  handleAnimationGoogle(){
    setState(() {
      leftPaddingGoogle = 10;
      rightPaddingGoogle = 10;
      signInStartGoogle = true;
    });
    
  }

  handleReverseAnimationGoogle (){
    setState(() {
      leftPaddingGoogle = 20;
      rightPaddingGoogle = 20;
      signInStartGoogle = false;
    });
  }


  handleAnimationFb(){
    setState(() {
      leftPaddingFb = 5;
      rightPaddingFb = 5;
      signInStartFb = true;
    });
    
  }

  handleReverseAnimationFb (){
    setState(() {
      leftPaddingFb = 10;
      rightPaddingFb = 10;
      signInStartFb = false;
    });
  }




  handleAfterSignupGoogle (){
    setState(() {
      leftPaddingGoogle = 20;
      rightPaddingGoogle = 20;
      Future.delayed(Duration(milliseconds: 1000)).then((f){
      nextScreenReplace(context, IntroPage());
    });
    });
  }


  handleAfterSignupFb (){
    setState(() {
      leftPaddingFb = 10;
      rightPaddingFb = 10;
      Future.delayed(Duration(milliseconds: 1000)).then((f){
      nextScreenReplace(context, IntroPage());
    });
    });
  }




  
  
  

  @override
  Widget build(BuildContext context) {
    final SignInBloc sb = Provider.of<SignInBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage(Config().splashIcon),
                        height: 130,
                      ),
                    SizedBox(height: 40,),
                    Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  RichText(
            text: TextSpan(
              text: 'Welcome to ',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700]
                  ),
              children: <TextSpan>[
                TextSpan(
                    text: 'News',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                TextSpan(
                    text: 'Hour',
                    style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 5),
                    child: Text(
                      'Sign In to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black45),
                    ),
                  )
                ],
              ),
                  ],
                )),
            
            Container(
                  height: 45,
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.12, right: MediaQuery.of(context).size.width * 0.12),
                  
                  
                    
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(25)),
                  child: AnimatedPadding(
                      padding: EdgeInsets.only(
                          left: leftPaddingGoogle, right: rightPaddingGoogle, ),
                      duration: Duration(milliseconds: 1000),
                      child: AnimatedCrossFade(

                        
                        duration: Duration(milliseconds: 400),
                        firstChild: _firstChildGoogle(sb),
                        secondChild: signInCompleteGoogle == false ? _secondChildGoogle() : _firstChildGoogle(sb),
                        crossFadeState: signInStartGoogle == false 
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                      ))),

              
            

            SizedBox(height: 15,),

            Container(
                  height: 45,
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.12, right: MediaQuery.of(context).size.width * 0.12),
                  
                  decoration: BoxDecoration(
                      color: Colors.indigo[400],
                      borderRadius: BorderRadius.circular(25)),
                  child: AnimatedPadding(
                      padding: EdgeInsets.only(
                          left: leftPaddingFb, right: rightPaddingFb, ),
                      duration: Duration(milliseconds: 1000),
                      child: AnimatedCrossFade(

                        
                        duration: Duration(milliseconds: 400),
                        firstChild: _firstChildFb(sb),
                        secondChild: signInCompleteFb == false ? _secondChildFb() : _firstChildFb(sb),
                        crossFadeState: signInStartFb == false 
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                      ))),

              
            

            Spacer(),
            Text("Don't have social accounts? "),
            FlatButton(
                child: Text('Continue with Email  >>', style: TextStyle(color: Colors.deepPurpleAccent),),
                onPressed: (){
                nextScreen(context, SignUpPage());
              },
             
            ),
            SizedBox(height: 15,),
            
          ],
        ),
      ),
    );
  }

  Widget _firstChildGoogle(sb) {
    return FlatButton.icon(
      icon: signInCompleteGoogle == false ?
      Icon(FontAwesomeIcons.google, size: 22, color: Colors.white,):
      Icon(Icons.done, size: 25, color: Colors.white,),


      label: signInCompleteGoogle == false ? 
      Text(' Sign In with Google', style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),) :
      Text(' Completed', style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),),
      onPressed: () {
        handleGoogleSignIn();
        
          
        
      },
    );
  }

  Widget _secondChildGoogle(){
    return Container(
      padding: EdgeInsets.all(10),
      height: 45,
      width: 45,
      child: CircularProgressIndicator(
        strokeWidth: 3,
      ));
  }


  Widget _firstChildFb(sb) {
    return FlatButton.icon(
      icon: signInCompleteFb == false ?
      Icon(FontAwesomeIcons.facebook, size: 22, color: Colors.white,):
      Icon(Icons.done, size: 25, color: Colors.white,),


      label: signInCompleteFb == false ? 
      Text(' Sign In with Facebook', style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),) :
      Text(' Completed', style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),),
      onPressed: () {
        
        handleFacebbokLogin();
          
        
      },
    );
  }

  Widget _secondChildFb(){
    return Container(
      padding: EdgeInsets.all(10),
      height: 45,
      width: 45,
      child: CircularProgressIndicator(
        strokeWidth: 3,
      ));
  }
}
