import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../app_context.dart' as appContext;

var LABEL_REGIST_PAGE = "Regist Page";
var LABEL_REGIST_BUTTON = "Regist";

class RegistPage extends StatelessWidget {
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
            child: Text(LABEL_REGIST_BUTTON),
            onPressed: () async {
              print("on pressed");
              print(emailController.text);
              print(passwordController.text);
              var email = emailController.text;
              var pass = passwordController.text;
              try {
                await appContext.apiClient.registAtFirebase(email, pass);
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
                    Text("Move To Login User Page",
                      style: TextStyle(decoration: TextDecoration.underline, color:Colors.blue),
                    ),
                  onTap: (){
                    print("regist page btn");
                    Navigator.pop(context);
                  },
                )
            )
        ],
      );
    };
    return Scaffold(
      appBar: AppBar(title: Text(LABEL_REGIST_PAGE),),
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

