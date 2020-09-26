import 'package:flutter/material.dart';
import 'package:myapp/reigstpage.dart';
import './login.dart';
import './loginpage.dart';

import './fileinput.dart' as fi;
import './fileinput_web.dart' as fi;
import './dynamicgridview.dart' as dyna;

/*
[Memo]
# Firebase Storage Rule
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /users/{uid}/{allPaths=**} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}


# Firebase Store Rule
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{uid}/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}

[ref]
https://medium.com/@khreniak/cloud-firestore-security-rules-basics-fac6b6bea18e
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
      home: LoginPage(),
 

    )
  );
}

 
class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: dyna.DynamicGridView(dyna.SampleDynamicGridViewClient(),2),
      ),
      appBar: AppBar(title: Text("Home"),),
      //
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () async {
          // file upload   
          var filedata = await fi.FileInputBuilderWeb().create().getFiles();
          if(filedata != null && filedata.length > 0) {
            var binary = await filedata.first.getBinaryData();
            uploadBuffer(binary);
          }
        }),    
      );
  }
}
/*
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

    return Scaffold(
      appBar: AppBar(title: Text("Home"),),
      body: Container(
        margin: EdgeInsets.all(33),
        child: FutureBuilder<List<String>>(
          future: listFiles(),
          builder: (context, snapshot) {
          if(snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 2,
              children: snapshot.data.map((e) {
                return  Container(
                  //color: Colors.black38,
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10.0) ,
                    border: Border.all(color:Colors.grey,width: 2)),
                  child: MyImageWidget(e)//Text('${e}'),
                );
              }).toList());
                 
          }else {
            return  Container(child: Text("Loading.."),);
          }
       },)),
      //
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () async {
          // file upload   
          var filedata = await fi.FileInputBuilderWeb().create().getFiles();
          if(filedata != null && filedata.length > 0) {
            var binary = await filedata.first.getBinaryData();
            uploadBuffer(binary);
          }
        }),      
      );
  }
}

class MyImageWidget extends StatefulWidget {
  String uuid;
  MyImageWidget(this.uuid);

  @override
  _MyImageWidgetState createState() => _MyImageWidgetState();
}

class _MyImageWidgetState extends State<MyImageWidget> {
  @override
  Widget build(BuildContext context) {
    getUrl(widget.uuid);
    //return Container(child: Text("xx"),);
    
    return FutureBuilder(
      future: getUrl(widget.uuid),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          Uri d  = snapshot.data;
          return Image.network(d.toString());
        } else {
          return  Container(child: Text("Loading.."),);
        }
      });
    
  }
}
*/


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
