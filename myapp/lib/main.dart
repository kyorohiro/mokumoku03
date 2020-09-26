import 'package:flutter/material.dart';
import 'package:myapp/reigstpage.dart';
import './login.dart';
import './loginpage.dart';

import './fileinput.dart' as fi;
import './fileinput_web.dart' as fi;
import 'package:firebase/firebase.dart' as fb;
import 'dart:html' as html;

/*
[Memo]
Firebase Storage Rule
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{uid}/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
*/


void main() {
  setupFirebase();
  runApp(
    MaterialApp(
      routes: <String, WidgetBuilder>{
        "/login": (context) => LoginPage(),
        "/regist":(context) => RegistPage(),
        "/home": (context) => MyHome(),
      },
      home: LoginPage()

    )
  );
}

xx() async {
  fb.StorageReference ref = fb.storage().ref('pkg_firebase/examples/storage');
  var file = html.Blob(["Hello,World!!"]);
  var uploadTask = ref.child("test2.txt").put(file);
  try {
    await uploadTask.future;
  } catch(e) {
    print(e);
  }
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var gen = (int i) {
      return Container(
        child: Center(child: Text("${i}")),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black45,
          ),
          borderRadius: BorderRadius.circular(10),
        
        ),
      );
    };
    var grid =  GridView.count(
      crossAxisCount: 3,
      children: List<int>.generate(100, (index) => index).map((e) => gen(e)).toList()
    );
    return Scaffold(
      appBar: AppBar(title: Text("Home"),),
      body: Container(
        margin: EdgeInsets.all(33),
        child:grid,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () async {
          print("pressed photo button");
          var filedata = await fi.FileInputBuilderWeb().create().getFiles();
          if(filedata != null && filedata.length > 0) {
            print("selected a file 00");            
            var storageRef = fb.storage().ref("MmPcQoCv7ZgH0oSCDYjWxuiy4kw2");
            print("selected a file 3");            
            var testRef = storageRef.child("xx.png");
            print("selected a file 4"); 
            var binary = await filedata.first.getBinaryData();
            print("selected a file 5");            
            testRef.put(binary);            
            print("selected a file 6");            
          } else {
            print("no not select a file");
          }
        }),
      
      
      );
  }
}




////
////<!-- The core Firebase JS SDK is always required and must be listed first -->
////<script src="https://www.gstatic.com/firebasejs/7.21.0/firebase-app.js"></script>
////
////<!-- TODO: Add SDKs for Firebase products that you want to use
////     https://firebase.google.com/docs/web/setup#available-libraries -->
////
////<script>
////  // Your web app's Firebase configuration
////  var firebaseConfig = {
////    apiKey: "AIzaSyBiMJJy4UT5wXDmuGAuIpH3LDf9xfJN-KM",
////    authDomain: "mokumoku00003.firebaseapp.com",
////    databaseURL: "https://mokumoku00003.firebaseio.com",
////    projectId: "mokumoku00003",
////    storageBucket: "mokumoku00003.appspot.com",
////    messagingSenderId: "1011491025362",
////    appId: "1:1011491025362:web:bbee4b2beb78920450980b"
////  };
////  // Initialize Firebase
////  firebase.initializeApp(firebaseConfig);
////</script>
///
