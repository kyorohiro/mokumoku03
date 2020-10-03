import 'package:flutter/material.dart';
import 'api_client.dart';
import 'dart:async';

var LABEL_LOGOUT_PAGE = "Logout Page";


class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {

 StreamSubscription<Null> subscription;

 @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    print("dispose");
    if(subscription != null) {
      subscription.cancel();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var formItemSet = (BuildContext context) {
      return Column(
        children: [
          Container(height: 80,),
          RaisedButton(
            child: Text("Logout"),
            onPressed: () async {
              try {
                // todo logout
                //await loginAtFirebase(email, pass);
                print("click ologout");
                await logout();
                Navigator.popAndPushNamed(context, "/login");//??
              } catch(e) {
                if(e is LoginErrorMessage) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("${e.message}")));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("${e}")));
                }
              }
            }),
        ],
      );
    };
    return Scaffold(
      appBar: AppBar(title: Text(LABEL_LOGOUT_PAGE),),
      body: Builder(builder: (context) {
          return 
          Center(child: 
            Container(
              constraints: BoxConstraints(
                maxWidth: 400,
              ),
              margin: EdgeInsets.all(20),
              child: Form(child: formItemSet(context))
              )
            );
        }
      )
    );
  }
}
