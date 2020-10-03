import 'package:flutter/material.dart';
import 'package:myapp/reigstpage.dart';
import 'api_client.dart';
import './loginpage.dart';
import './logoutpage.dart';
import './fileinput.dart' as fi;
import './fileinput_web.dart' as fi;
import './dynamicgridview.dart' as dyna;
import './app_context.dart' as appContext;

// String := image url
class MyDynamicGridViewClient extends  dyna.DynamicGridViewClient<String> {
  int i=0;
  Object lastKey;
  Future<List<String>> getData() async {
    //
    // TODO to reimplements about listFiles's lastkey  
    var result = await listFiles(lastKey:lastKey);
    lastKey = result.lastkey;
    return  result.data;
  }
  Widget createWidget(String v) {
    return  Container(
            //color: Colors.black38,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(10.0) ,
              border: Border.all(color:Colors.grey,width: 2)),
            child: MyImageWidget(v)//Text('${e}'),
          );
    //return Container(child: MyImageWidget(v),);
  }
}

class MyImageListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: dyna.DynamicGridView(MyDynamicGridViewClient(),3),
      ),
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout), 
            onPressed: (){
              print("click logout");
              Navigator.pushNamed(context, appContext.routeLogoutPagePath);
            })
        ],

        
        ),
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


