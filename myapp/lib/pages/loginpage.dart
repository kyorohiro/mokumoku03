import 'package:flutter/material.dart';
import '../services/api_client.dart';
import 'dart:async';
import '../app_context.dart' as appContext;
var LABEL_LOGIN_PAGE = "Login Page";


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

 StreamSubscription<Null> subscription;

moveToHome(){
  Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
}
 @override
  void initState() {
    super.initState();
    print("initState");
    
    print(appContext.apiClient.logined());
    subscription =  appContext.apiClient.loginedStream().listen((event) {
      // life time?
      // move to another page? dead this state?
      print("=========== logined from stream");
      moveToHome();
      print(appContext.apiClient.logined());
    });

    if(appContext.apiClient.logined()) {
       moveToHome();
    }
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
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
  
    var formItemSet = (BuildContext context) {
      return Column(
        children: [
          Container(height: 80,),
          TextFormField(
            controller: emailController ,
            decoration: InputDecoration(
              hintText: "Email Address"
            ),
          ),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password"
            ),
          ),
          RaisedButton(
            child: Text("Login"),
            onPressed: () async {
              print("on pressed");
              print(emailController.text);
              print(passwordController.text);
              var email = emailController.text;
              var pass = passwordController.text;
              try {
                print("click login");
                if(appContext.apiClient.logined()) {
                  moveToHome();// todo wrong
                } else {
                  await appContext.apiClient.login(email, pass);
                }
                print("clicked login");

              } catch(e) {
                if(e is LoginErrorMessage) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("${e.message}")));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("${e}")));
                }
              }
            }),
            Container(
              alignment: Alignment.bottomRight,
              width: double.infinity,
              child:  GestureDetector(
                  child: 
                    Text("Regist User Page",
                      style: TextStyle(decoration: TextDecoration.underline, color:Colors.blue),
                    ),
                  onTap: (){
                    print("regist page btn");
                    Navigator.pushNamed(context, appContext.routeRegistPagePath);
                  },
                )
            )
           
        ],
      );
    };
    return Scaffold(
      appBar: AppBar(title: Text(LABEL_LOGIN_PAGE),),
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

class LoginPage_ extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
  
    var formItemSet = (BuildContext context) {
      return Column(
        children: [
          Container(height: 80,),
          TextFormField(
            controller: emailController ,
            decoration: InputDecoration(
              hintText: "Email Address"
            ),
          ),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password"
            ),
          ),
          RaisedButton(
            child: Text("Login"),
            onPressed: () async {
              print("on pressed");
              print(emailController.text);
              print(passwordController.text);
              var email = emailController.text;
              var pass = passwordController.text;
              try {
                await appContext.apiClient.login(email, pass);
              } catch(e) {
                if(e is LoginErrorMessage) {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("${e.message}")));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("${e}")));
                }
              }
            }),
            Container(
              alignment: Alignment.bottomRight,
              width: double.infinity,
              child:  GestureDetector(
                  child: 
                    Text("Regist User Page",
                      style: TextStyle(decoration: TextDecoration.underline, color:Colors.blue),
                    ),
                  onTap: (){
                    print("regist page btn");
                    Navigator.pushNamed(context, appContext.routeRegistPagePath);
                  },
                )
            )
           
        ],
      );
    };
    return Scaffold(
      appBar: AppBar(title: Text(LABEL_LOGIN_PAGE),),
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

