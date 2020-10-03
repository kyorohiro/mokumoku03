import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../utils/fileinput.dart' as fi;
import '../utils/fileinput_web.dart' as fi;
import 'dynamicgridview.dart' as dyna;
import '../app_context.dart' as appContext;

// String := image url
class MyDynamicGridViewClient extends dyna.DynamicGridViewClient<String> {
  int i = 0;
  Object lastKey;
  Future<List<String>> getData() async {
    //
    // TODO to reimplements about listFiles's lastkey
    //var result = await appContext.apiClient.listFiles(lastKey:lastKey);
    //lastKey = result.lastkey;
    //return  result.data;
    return appContext.imgManager.getImageUrls();
  }

  Widget createWidget(BuildContext context,String uuidForImage) {
    var body = Container(
        //color: Colors.black38,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey, width: 2)),
        child: MyImageWidget(uuidForImage) //Text('${e}'),
        );
    //String url = appContext.apiClient.getUrl(v);
    return GestureDetector(
      onTap: () {
        print("tap image");
        Navigator.pushNamed(context, appContext.routeImage, arguments: {"name":uuidForImage});
      },
      child: body,
    );

    //return Container(child: MyImageWidget(v),);
  }
}

class MyImageListPage extends StatelessWidget {
  GlobalKey imagesWidgetGlobalKey = GlobalKey();
  MyImageListPage() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: dyna.DynamicGridView(MyDynamicGridViewClient(), 3,
            key: imagesWidgetGlobalKey),
      ),
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
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
            if (filedata != null && filedata.length > 0) {
              var binary = await filedata.first.getBinaryData();
              var uuid = await appContext.apiClient.uploadBuffer(binary);
              //appContext.imgManager.putUuid(uuid);
              imagesWidgetGlobalKey.currentState.setState(() {});
            }
          }),
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
