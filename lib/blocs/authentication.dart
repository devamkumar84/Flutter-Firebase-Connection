import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends ChangeNotifier{
  Authentication(){
    checkSignIn();
  }
  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _checkErrorCode;
  String? get checkErrorCode => _checkErrorCode;

  bool? _hasError;
  bool? get hasError => _hasError;

  bool? _hasCheckError;
  bool? get hasCheckError => _hasCheckError;

  bool? _hasGoogleError;
  bool? get hasGoogleError => _hasGoogleError;

  bool? _hasFbError;
  bool? get hasFbError => _hasFbError;

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  String? _name;
  String? get name => _name;

  String? _uid;
  String? get uid => _uid;

  String? _email;
  String? get email => _email;

  String? _signInProvider;
  String? get signInProvider => _signInProvider;

  String? timestamp;

  final GoogleSignIn _googlSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool?> checkInternet()async {
    bool? internet;
    try{
      final result = await InternetAddress.lookup('google.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        debugPrint('Connected');
        internet = true;
      }
    }on SocketException catch (_){
      debugPrint('Not Connected');
      internet = false;
    }
    return internet;
  }
  Future getTimeStamp()async {
    DateTime now = DateTime.now();
    String formatTimestamp = DateFormat('yyyyMMddHHmmss').format(now);
    timestamp = formatTimestamp;
  }
  Future signUpWithEmailPassword(username, email, password)async {
    try {
      final User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      )).user;
      assert(user != null);
      await user!.getIdToken();
      _name = username;
      _email = user.email;
      _uid = user.uid;
      _signInProvider = 'email';

      _hasError = false;
      _isLogin = true;
    } on FirebaseAuthException catch (e) {
      _hasError = true;
      _isLogin = false;
      if (e.code == 'weak-password') {
        _errorCode = 'The password provided is too weak.';
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _errorCode = 'The account already exists for that email.';
        debugPrint('The account already exists for that email.');
      } else {
        _errorCode = e.toString();
      }
    } catch (e) {
      _hasError = true;
      _isLogin = false;
      _errorCode = e.toString();
      debugPrint(e.toString());
    }
    notifyListeners();
  }
  Future signInWithEmailPassword(email, password)async {
    try {
      final User user = (await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      )).user!;
      assert(user != null);
      await user.getIdToken();
      final User currentUser = _firebaseAuth.currentUser!;
      _uid = currentUser.uid;
      _signInProvider = 'email';
      _isLogin = true;
      _hasCheckError = false;
    } catch(e){
      _hasCheckError = true;
      _isLogin = false;
      _checkErrorCode = e.toString();
    }
    notifyListeners();
  }
  Future signInWithGoogle()async {
    final GoogleSignInAccount? googleUser = await _googlSignIn.signIn();
    if(googleUser != null){
      try{
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        _hasGoogleError = false;
        _isLogin = true;
      }catch(e){
        _hasGoogleError = true;
        _isLogin = false;
        _checkErrorCode = e.toString();
      }
      notifyListeners();
    }else {
      _hasGoogleError = true;
      _isLogin = false;
      notifyListeners();
    }
  }
  Future signInWithFb()async {
    final LoginResult facebookLoginResult = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    if(facebookLoginResult.status == LoginStatus.success){
      final accessToken = await FacebookAuth.instance.accessToken;
      if(accessToken != null){
        try{
          final AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
          await _firebaseAuth.signInWithCredential(credential);
          _hasFbError = false;
          notifyListeners();
        }catch(e){
          _hasFbError = true;
          _checkErrorCode = e.toString();
          notifyListeners();
        }
      }
    }else{
      _hasFbError = true;
      _checkErrorCode = 'Cancel or Error';
      notifyListeners();
    }
  }
  Future saveToFireStore()async {
    final DocumentReference ref = FirebaseFirestore.instance.collection('users').doc(_uid);
    var userData = {
      'name' : _name,
      'email': _email,
      'uid' : _uid,
      'timestamp' : timestamp,
    };
    await ref.set(userData);
  }
  Future getUserDataFromFireStore(uid)async{
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((DocumentSnapshot snap){
      _name = snap['name'];
      _email = snap['email'];
      _uid = snap['uid'];
      print(_name);
    });
    notifyListeners();
  }
  Future saveDataToSp()async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString('name', _name!);
    await sp.setString('email', _email!);
    await sp.setString('uid', _uid!);
    await sp.setString('signInProvider', _signInProvider!);
  }
  Future getDataFromSp()async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString('name');
    _email = sp.getString('email');
    _uid = sp.getString('uid');
    _signInProvider = sp.getString('signInProvider');
    notifyListeners();
  }
  Future setSignIn()async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isLogin = true;
    notifyListeners();
  }
  void checkSignIn()async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isLogin = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }
  Future signOut()async{
    await _firebaseAuth.signOut();
    await _googlSignIn.signOut();
    _isLogin = false;
    notifyListeners();
  }
  Future clearAllData()async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }
  Future afterUserSignOut()async {
    await clearAllData();
    _isLogin = false;
    notifyListeners();
  }
}