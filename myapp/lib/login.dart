
import 'dart:async';
import 'dart:typed_data';

import 'package:firebase/firebase.dart' as fb;
import './uuid.dart' as uuid;

fb.App gfirebaseApp;


typedef OnSignedIn = void Function();
typedef OnNoSignedIn = void Function();


StreamController<Null> _logined = StreamController<Null>.broadcast();
Stream<Null> logined(){
  return _logined.stream;
}

//
// Firebase
//
setupFirebase({OnSignedIn onSignedIn, OnNoSignedIn onNoSignedIn}) {
  try {
    print("fb init");
    gfirebaseApp = fb.initializeApp(
      apiKey: "AIzaSyBiMJJy4UT5wXDmuGAuIpH3LDf9xfJN-KM ",
      authDomain: "mokumoku00003.firebaseapp.com",
      projectId: "mokumoku00003",
      storageBucket: "mokumoku00003.appspot.com",
      appId: "1:1011491025362:web:bbee4b2beb78920450980b"
    );
    gfirebaseApp.auth().onAuthStateChanged.listen((user) {
      print("user:${user}");
      if(user != null) {
        if(onSignedIn != null){onSignedIn();}
        _logined.add(null);
      }else {
        if(onNoSignedIn != null){onNoSignedIn();}
      }
    });
  } catch(e) {
    print("fb error ${e}");
  } finally {
    print("fn fini");
  }
}

loginAtFirebase(String email, String password) async {
  try {
    print("fn slog");
    var userCredential = await fb.auth().signInWithEmailAndPassword(email, password);
    print("xx:${userCredential.user.email}");
    print("xx:${userCredential.additionalUserInfo.username}");
  } catch(e) {
    print("fb error ${e}");
    throw LoginErrorMessage()..message="${e}";
  } finally {
     print("fn elog");
  }
}

registAtFirebase(String email, String password) async {
  try {
    print("fn slog");
    var userCredential = await fb.auth().createUserWithEmailAndPassword(email, password);
    //signInWithEmailAndPassword(email, password);
    print("xx:${userCredential.additionalUserInfo}");
    print("xx:${userCredential.additionalUserInfo.username}");
  } catch(e) {
    print("fb error ${e}");
    throw LoginErrorMessage()..message="${e}";
  } finally {
     print("fn elog");
  }
}

// path **/**/xx.png  is ok, /**/**.png is ng
uploadBuffer(Uint8List buffer, {String path}) async {
  uploadBlob(buffer, path:path);
}

uploadBlob(dynamic blob, {String path}) async {
  if(path == null) {
    path = uuid.Uuid.createV1() +"_"+ uuid.Uuid.createUUID();
  }
  var storageRef = fb.storage().ref(fb.auth().currentUser.uid);
  var testRef = storageRef.child(path);        
  testRef.put(blob); 
}

class LoginErrorMessage {
  String message;
}

