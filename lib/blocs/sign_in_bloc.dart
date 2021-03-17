
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:news_app/pages/intro.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInBloc extends ChangeNotifier {
  

  SignInBloc (){
    checkSignIn();
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  final FacebookLogin fbLogin = new FacebookLogin();
  String randomUserImageUrl = 'https://img.pngio.com/avatar-business-face-people-icon-people-icon-png-512_512.png';



  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorCode;
  String get errorCode => _errorCode;

  bool _userExists = false;
  bool get userExists => _userExists;

  String _name;
  String get name => _name;

  String _uid;
  String get uid =>_uid;

  String _email;
  String get email => _email;

  String _imageUrl;
  String get imageUrl => _imageUrl;


  String timestamp;



  Future signInWithGoogle() async {
    
    final GoogleSignInAccount googleUser = await _googlSignIn.signIn().catchError((error) => print('error : $error'));
    if(googleUser != null){
      try{
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

      FirebaseUser userDetails = (await _firebaseAuth.signInWithCredential(credential)).user;
      
      this._name = userDetails.displayName;
      this._email = userDetails.email;
      this._imageUrl = userDetails.photoUrl;
      this._uid = userDetails.uid;
      
      _hasError = false;
      notifyListeners();
    }
    
    catch(e){
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
    } else{
      _hasError = true;
      notifyListeners();
    }

    
  }




  Future logInwithFacebook() async {

      FirebaseUser currentUser;
      final FacebookLoginResult facebookLoginResult =  await fbLogin.logIn(['email', 'public_profile']).catchError((error) => print('error: $error'));
      if(facebookLoginResult.status == FacebookLoginStatus.cancelledByUser){
        _hasError = true;
        _errorCode = 'cancel';
        notifyListeners();
      } else if(facebookLoginResult.status == FacebookLoginStatus.error){
        _hasError = true;
        notifyListeners();
      } else{
        try {
          if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
          FacebookAccessToken facebookAccessToken = facebookLoginResult.accessToken;
          final AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: facebookAccessToken.token);
          final FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
          assert(user.email != null);
          assert(user.displayName != null);
          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);
          currentUser = await _firebaseAuth.currentUser();
          assert(user.uid == currentUser.uid);

          this._name = user.displayName;
          this._email = user.email;
          this._imageUrl = user.photoUrl;
          this._uid = user.uid;
        
        
          _hasError = false;
          notifyListeners();
      }
    } catch (e) {
        _hasError = true;
        _errorCode = e.code;
        notifyListeners();
      }
    
    
    }
  }



  Future signUpwithEmailPassword (userName,userEmail, userPassword) async{
    try{
      final FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: userEmail,password: userPassword,)).user;
      assert(user != null);  
      assert(await user.getIdToken() != null);
      this._name = userName;
      this._uid = user.uid;
      this._imageUrl = randomUserImageUrl;
      this._email = user.email;

      _hasError = false;
      notifyListeners();
    }catch(e){
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
    
  }



  Future signInwithEmailPassword (userEmail, userPassword)async{
    try{
        final FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: userEmail, password: userPassword)).user;    
        assert(user != null);    
        assert(await user.getIdToken() != null);    
        final FirebaseUser currentUser = await _firebaseAuth.currentUser();    
        this._uid = currentUser.uid;

      _hasError = false;
      notifyListeners();
    }catch(e){
      _hasError = true;
      _errorCode = e.code;
      notifyListeners();
    }
  }





  Future checkUserExists () async {
    await Firestore.instance.collection('users').getDocuments().then((QuerySnapshot snap) {
      List values = snap.documents;
      List uids =[];
      values.forEach((element) {
        uids.add(element['uid']);
      });
      if(uids.contains(_uid)) {
        _userExists = true;
        print('User exists');     
        
      } else{
        _userExists = false;
        print('new User');
      }
      notifyListeners();

      
    });
  }




  Future saveToFirebase() async {
    final DocumentReference ref = Firestore.instance.collection('users').document(uid);
    await ref.setData({
      'name': _name,
      'email': _email,
      'uid': _uid,
      'image url': _imageUrl,
      'timestamp': timestamp,
      'loved items' : [],
      'bookmarked items' : []
    });
    
  }



  Future getTimestamp() async {
    DateTime now = DateTime.now();
    String _timestamp = DateFormat('yyyyMMddHHmmss').format(now);
    timestamp = _timestamp;
  }




  Future saveDataToSP() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString('name', _name);
    await sharedPreferences.setString('email', _email);
    await sharedPreferences.setString('image url', _imageUrl);
    await sharedPreferences.setString('uid', _uid);
    
  }



  Future getUserData (uid) async{
    await Firestore.instance.collection('users').document(uid).get().then((DocumentSnapshot snap) {
      this._uid = snap.data['uid'];
      this._name = snap.data['name'];
      this._email = snap.data['email'];
      this._imageUrl = snap.data['image url'];
      print(_name);
    });
    notifyListeners();
    
  }

  


  handleAfterSignup (context){
    Future.delayed(Duration(milliseconds: 1000)).then((f){
      nextScreenReplace(context, IntroPage());
    });
  }

  
  
  
  Future setSignIn ()async{
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed in', true);
    notifyListeners();
  }

  void checkSignIn () async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed in')?? false;
    notifyListeners();
  }


  


  

}
