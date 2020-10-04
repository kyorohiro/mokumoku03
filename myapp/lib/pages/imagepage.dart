import 'package:flutter/material.dart';
import '../app_context.dart' as appContext;


class ImagePage extends StatelessWidget {
  final String uuid;
  ImagePage(this.uuid) {
  }
  @override
  Widget build(BuildContext context) {
    //var args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text("IMG"),),
      body: MyImageWidget(uuid),
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
    //
    // login
    return FutureBuilder(
        future: appContext.apiClient.getUrl(widget.uuid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Uri d = snapshot.data;
            var img = Image.network(d.toString(),fit: BoxFit.fill,);
            return Container(
              width: double.infinity,
//              height: 200,
              child: img,
            );
            //return Image.network(d.toString());
          } else {
            return Container(
              child: Text("Loading.."),
            );
          }
        });
  }
}