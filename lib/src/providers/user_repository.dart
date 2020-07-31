import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'dart:collection';
import '../repository/repo.dart';
import 'connectivity.dart';
import 'package:kosherparatodos/src/providers/preferences.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Choosing,
  Register,
  Registering,
}

class UserRepository with ChangeNotifier {
  final FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  final Repository repo = FirestoreProvider();
  final _conex = ConnectivityProvider.getInstance();
  List _adminList = [];
  final Preferences _prefs = Preferences();

  UnmodifiableListView get adminList => UnmodifiableListView(_adminList);

  final Repository _repository = FirestoreProvider();

  set adminList(List adminList) {
    _adminList = adminList;
    notifyListeners();
  }

  Future getAdminList() async {
    await _repository.getUsersAdmin().forEach((documents) {
      _adminList = documents.data['userID'] as List;
    });
  }

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    getAdminList();
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signup(
      String name, String lastName, String email, String password) async {
    try {
      if (_conex.hasConnection) {
        _status = Status.Registering;
        notifyListeners();
        AuthResult firebaseUser = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (firebaseUser != null) {
          final Map nombre = {
            'nombre': name,
            'apellido': lastName,
          };
          final HttpsCallable callable =
              CloudFunctions.instance.getHttpsCallable(
            functionName: 'addUser',
          );
          await callable.call(<String, dynamic>{
            'nombre': nombre,
            'uid': firebaseUser.user.uid,
          });
          _status = Status.Register;
          notifyListeners();
        } else {
          _status = Status.Register;
          notifyListeners();
          throw 'Datos incorrectos';
        }
      } else {
        throw 'No hay conexion';
      }
    } catch (e) {
      _status = Status.Register;
      throw e.toString();
    }
  }

  goLogin() {
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<void> goSignup() async {
    _status = Status.Register;
    notifyListeners();
  }

  Future<void> goWelcome() async {
    _status = Status.Choosing;
    notifyListeners();
  }

  Future signOut() async {
    await _auth.signOut();
    _prefs.clear();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future signOutOnRegister() async {
    _auth.signOut();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null && _status != Status.Register) {
      _status = Status.Choosing;
    } else {
      if (_status == Status.Registering || _status == Status.Register) {
        _status = Status.Register;
      } else {
        _user = firebaseUser;
        _status = Status.Authenticated;
      }
    }
    notifyListeners();
  }

  Future<void> beforeSignIn(String email, String password) async {
    try {
      final cone = ConnectivityProvider.getInstance();
      if (cone.hasConnection) {
        _status = Status.Authenticating;
        notifyListeners();
        await repo.isAuthenticated(email).then((data) async {
          if (data.documents.isEmpty ||
              data.documents[0].data['estaAutenticado'] == true) {
            if (!await signIn(email, password)) {
              throw 'Ingreso incorrecto.';
            }
          } else {
            throw 'Expere confirmacion por mail.';
          }
        });
      } else {
        throw 'No hay conexion a internet';
      }
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw e.toString();
    }
  }
}
