import 'package:flutter/material.dart';
import 'package:myapp/pages/reigstpage.dart' as page;
import 'services/api_client.dart';
import 'pages/loginpage.dart' as page;
import 'pages/logoutpage.dart' as page;
import 'pages/imagelistpage.dart' as page;

import './app_context.dart' as appContext;
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

lighting_2_sutton_surrey.jpg
https://free-images.com/display/lighting_2_sutton_surrey.html
lighting_dept_high_st.jpg
https://free-images.com/display/lighting_dept_high_st.html


[Today TODO]
 - (asis ok) Logout 
 - (asis ok, todo refactoring)Upload then  display a image in image list page. 
 - click and display expand image.
 - reize image for image list page 
 - image cached and think about outofmemory
*/


void main() {
  appContext.apiClient.setupClient();
  runApp(
    MaterialApp(
      routes: <String, WidgetBuilder>{
        appContext.routeLoginPagePath : (context) => page.LoginPage(),
        appContext.routeRegistPagePath:(context) => page.RegistPage(),
        appContext.routeHomePagePath: (context) => page.MyImageListPage(),
        appContext.routeLogoutPagePath: (context) => page.LogoutPage(),
        appContext.routeImage: (context) => ImagePage()
      },
      initialRoute: "/login",
    )
  );
}

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: MyImageWidget((args as Map)["name"]),
    );
  }
}


class MyImageWidget extends StatefulWidget {
  final String uuid;
  MyImageWidget(this.uuid);

  @override
  _MyImageWidgetState createState() => _MyImageWidgetState();
}

class _MyImageWidgetState extends State<MyImageWidget> {
  @override
  Widget build(BuildContext context) {
    appContext.apiClient.getUrl(widget.uuid);

    return FutureBuilder(
        future: appContext.apiClient.getUrl(widget.uuid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Uri d = snapshot.data;
            return Image.network(d.toString());
          } else {
            return Container(
              child: Text("Loading.."),
            );
          }
        });
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
