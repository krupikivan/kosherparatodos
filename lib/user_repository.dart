import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated, Choosing, Register, Registering }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

    Future<void> signup(String name, String email, String password) async {
     _status = Status.Registering;
      notifyListeners();
     return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((firebaseUser) async{
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'addUser',
      );
//    dynamic resp = await callable.call();
      await callable.call(<String, dynamic>{
        'name': name,
        'email': email,
        'uid': firebaseUser.user.uid,
      });
        _status = Status.Register;
      notifyListeners();
    }).catchError((onError){
              _status = Status.Register;
      notifyListeners();
    });
  }


  Future<void> goLogin() async{
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  
  Future<void> goSignup() async{
    _status = Status.Register;
    notifyListeners();
  }

  Future<void> goWelcome() async{
    _status = Status.Choosing;
    notifyListeners();
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Choosing;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}