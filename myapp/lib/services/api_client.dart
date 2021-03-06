import 'dart:async';
import 'dart:typed_data';

import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:uuid/uuid.dart';
import '../utils/uuid.dart' as uuid;
import 'dart:html' as html;

fb.App gfirebaseApp;

typedef OnSignedIn = void Function();
typedef OnNoSignedIn = void Function();

class ApiClient {
  StreamController<Null> _loginedStream = StreamController<Null>.broadcast();
  Stream<Null> loginedStream() {
    return _loginedStream.stream;
  }

  bool logined() {
    // todo
    return fb.auth().currentUser != null;
  }

//
// Firebase
//
  setupClient({OnSignedIn onSignedIn, OnNoSignedIn onNoSignedIn}) {
    try {
      print("fb init");
      gfirebaseApp = fb.initializeApp(
          apiKey: "AIzaSyBiMJJy4UT5wXDmuGAuIpH3LDf9xfJN-KM ",
          authDomain: "mokumoku00003.firebaseapp.com",
          projectId: "mokumoku00003",
          storageBucket: "mokumoku00003.appspot.com",
          appId: "1:1011491025362:web:bbee4b2beb78920450980b",
          databaseURL: "https://mokumoku00003.firebaseio.com");
      gfirebaseApp.auth().onAuthStateChanged.listen((user) {
        print("user:${user}");
        if (user != null) {
          if (onSignedIn != null) {
            onSignedIn();
          }
          _loginedStream.add(null);
        } else {
          if (onNoSignedIn != null) {
            onNoSignedIn();
          }
        }
      });
    } catch (e) {
      print("fb error ${e}");
    } finally {
      print("fn fini");
    }
  }

  login(String email, String password) async {
    try {
      print("fn slog");
      var userCredential =
          await fb.auth().signInWithEmailAndPassword(email, password);
      print("xx:${userCredential.user.email}");
      print("xx:${userCredential.additionalUserInfo.username}");
    } catch (e) {
      print("fb error ${e}");
      throw LoginErrorMessage()..message = "${e}";
    } finally {
      print("fn elog");
    }
  }

  logout() {
    fb.auth().signOut();
  }

  registAtFirebase(String email, String password) async {
    try {
      print("fn slog");
      var userCredential =
          await fb.auth().createUserWithEmailAndPassword(email, password);
      //signInWithEmailAndPassword(email, password);
      print("xx:${userCredential.additionalUserInfo}");
      print("xx:${userCredential.additionalUserInfo.username}");
    } catch (e) {
      print("fb error ${e}");
      throw LoginErrorMessage()..message = "${e}";
    } finally {
      print("fn elog");
    }
  }

  String createUUID() {
    return uuid.Uuid.createV1() + "_" + uuid.Uuid.createUUID();
  }

//Future<List<String>>
  Future<ListFilesResult> listFiles({Object lastKey}) async {
    var collectionRef = fb
        .firestore()
        .collection("users/${fb.auth().currentUser.uid}/files")
        .orderBy("name"); //.limit(5);
    print("lasyKey = ${lastKey}");
    //  [memo]
    //  ok : fb.firestore().collection("users/${fb.auth().currentUser.uid}/files").orderBy("name").limit(5);
    //  ng var x = fb.firestore().collection("users/${fb.auth().currentUser.uid}/files")
    //        x.orderBy("name");
    if (lastKey != null) {
      collectionRef = collectionRef.startAfter(
          snapshot: lastKey); //(snapshot:lastKey as DocumentSnapshot);
    }
    // for debug
    print("xx000");
    //collectionRef = collectionRef.limit(25);
    print("xx001");
    var x = await collectionRef.get();
    print("xx002");

    for (var d in x.docs) {
      print(d.id);
    }
    print("e ${x.size}");
    return ListFilesResult()
      ..data = x.docs.map((e) => e.id).toList()
      ..lastkey = (x.docs.length > 0 ? x.docs.last : lastKey);
  }

// path **/**/xx.png  is ok, /**/**.png is ng
  Future<String> uploadBuffer(Uint8List buffer,
      {String contentType = "application/octet-stream"}) async {
    String id = createUUID();
    // todo guard
    uploadBufferToStorage(buffer, name: id);
    addFileInfoToDB(id, contentType: contentType);
    return id;
  }

  addFileInfoToDB(String name,
      {String contentType = "application/octet-stream"}) async {
    try {
      // maybe wrong
      var docRef = await fb
          .firestore()
          .collection("users/${fb.auth().currentUser.uid}/files")
          .doc(name)
          .set({"v": 1, "name": name, "contentType": contentType});
      print("Document written with ID: ${docRef.id}");
    } catch (e) {
      print(e);
    }
  }

// path **/**/xx.png  is ok, /**/**.png is ng
  Future<String> uploadBufferToStorage(Uint8List buffer,
      {String name = null}) async {
    return uploadBlobToStorage(buffer, name: name);
  }

//
// todo s/images/files/g
//
  Future<String> uploadBlobToStorage(dynamic blob, {String name = null}) async {
    if (name == null) {
      name = createUUID();
    }
    var storageRef = fb.storage().ref("users/" + fb.auth().currentUser.uid);
    var testRef = storageRef.child("images/" + name);
    testRef.put(blob);
    return name;
  }

//
// todo s/images/files/g
//
  Future<Uri> getUrl(String name, {waittingForLogined=true}) async {
    for(int i=0;i<3;i++) {
      try {
          var storageRef = fb.storage().ref("users/" + fb.auth().currentUser.uid);
          var testRef = storageRef.child("images/" + name);

          var uri = await testRef.getDownloadURL();
          return uri;
      } catch (e) {
        print("error");
        await Future.delayed(Duration(seconds: 1));
        if(i>2){
        print("${e}");
          rethrow;
        }
      }
    }
  }
}

class ListFilesResult {
  List<String> data;
  Object lastkey;
}

class LoginErrorMessage {
  String message;
}

////
////var req = html.HttpRequest();
////req.onLoad.listen((event) {
////  print("onLoad S");
////  var blob = req.response;
////  print("${blob}");
////  print("onLoad E");
////});
////req.onError.listen((event) {
////  print("error");
////  print(event);
////});
////req.open("GET", uri.toString());
////req.send();
////
