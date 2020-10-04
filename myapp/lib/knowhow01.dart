//
// use http query paramter at flutter rpouter
//

import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
      onGenerateRoute: (RouteSettings settings) {
        var _uri = Uri.parse(settings.name);
        String path = _uri.path;
        Map<String,String> params = _uri.queryParameters;
        if(path.startsWith("/image")) {
          return MaterialPageRoute(
            settings: RouteSettings(
              name:"/image?uuid=${params['uuid']}"
            ),
            builder: (context) {
              return ImagePage(params["uuid"]);
            },
          );
        } else {
          return null;
        }
      },
      routes: {
        "/home" :(context)=> HomePage()
      } ,
      initialRoute: "/home",
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: RaisedButton(
        child: Text("move to /image?uuid=xxxx"),
        onPressed: () {
          Navigator.pushNamed(context, "/image?uuid=xxxx");
        },),
    ));
  }
}
class ImagePage extends StatelessWidget{
  String imageName;
  ImagePage(this.imageName){}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("${imageName}"),),
    );
  }
}
