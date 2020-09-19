import 'package:flutter/material.dart';
import 'package:myapp/reigstpage.dart';
import './login.dart';
import './loginpage.dart';


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
        onPressed: (){
          print("pressed photo button");
        }),
      
      
      );
    
 
////    return Container(
////      child: Text("Hello, World!!"),
////    );
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
