
import 'dart:async';
import 'dart:typed_data';

import 'package:firebase/firebase.dart' as fb;
import 'package:uuid/uuid.dart';
import './uuid.dart' as uuid;
import 'dart:html' as html;

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
      appId: "1:1011491025362:web:bbee4b2beb78920450980b",
      databaseURL: "https://mokumoku00003.firebaseio.com"
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



String createUUID() {
  return uuid.Uuid.createV1() +"_"+ uuid.Uuid.createUUID();
}

Future<List<String>> listFiles() async {
   var collectionRef = fb.firestore().collection("users/${fb.auth().currentUser.uid}/files");
   var x = await collectionRef.get();
   for(var d in x.docs ){
     print(d.id);
   }
   print(x.size);
   return x.docs.map((e) => e.id).toList();
}

// path **/**/xx.png  is ok, /**/**.png is ng
Future<String> uploadBuffer(Uint8List buffer, {String contentType="application/octet-stream"}) async {
  String id = createUUID();
  // todo guard
  uploadBufferToStorage(buffer,name: id);
  addFileInfoToDB(id,contentType:contentType);
  return id;
}



addFileInfoToDB(String name, {String contentType="application/octet-stream"}) async {
  try {
    // maybe wrong
    var docRef = await fb.firestore().collection("users/${fb.auth().currentUser.uid}/files").doc(name)
    .set({
      "v":1,
      "name":name,
      "contentType":contentType
    });
    print("Document written with ID: ${docRef.id}");
  } catch(e) {
    print(e);
  }
}

// path **/**/xx.png  is ok, /**/**.png is ng
Future<String> uploadBufferToStorage(Uint8List buffer, {String name=null}) async {
  return uploadBlobToStorage(buffer,name:name);
}

Future<String> uploadBlobToStorage(dynamic blob, {String name=null}) async {
  if(name == null) {
    name = createUUID();
  }
  var storageRef = fb.storage().ref("users/"+fb.auth().currentUser.uid);
  var testRef = storageRef.child("images/"+name);        
  testRef.put(blob); 
  return name;
}

Future<Uri> getUrl(String name) async  {
  var storageRef = fb.storage().ref("users/"+fb.auth().currentUser.uid);
  var testRef = storageRef.child("images/"+name);
  try {
    print("getDownload");
    var uri = await testRef.getDownloadURL();
    /*Future((){
      print("ZZ-------- ${uri.toString()}");
      var req = html.HttpRequest();
      req.onLoad.listen((event) {
        print("onLoad S");
        var blob = req.response;
        print("${blob}");        
        print("onLoad E");
      });
      req.onError.listen((event) {
        print("error");
        print(event);
      });
      req.open("GET", uri.toString());
      req.send();
    });*/
    return  uri;
  } catch(e) {
    print("error");
    print("${e}");
    rethrow;
  }
}

class LoginErrorMessage {
  String message;
}

