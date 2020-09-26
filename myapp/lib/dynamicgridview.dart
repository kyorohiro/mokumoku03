import 'package:flutter/material.dart';

//
// TODO 
// This widget expect  
//   - get many data at first client.getData()  
//
abstract class DynamicGridViewClient<X> {
  Future<List<X>> getData();
  Widget createWidget(X v);
}

class SampleDynamicGridViewClient extends  DynamicGridViewClient<String> {
    int i=0;
  Future<List<String>> getData() async {
    return List<String>.generate(100, (index) => "ZZ:${i++}");
  }
  Widget createWidget(String v) {
    return Container(child: Text(v),);
  }
}

//DynamicGridViewClient client = new  DynamicGridViewClient();

class DynamicGridView extends StatefulWidget {
  DynamicGridViewClient client;
  int crossAxisCount;
  DynamicGridView(this.client, this.crossAxisCount);
  @override
  _DynamicGridViewState createState() => _DynamicGridViewState();
}

class _DynamicGridViewState extends State<DynamicGridView> {
  List contents = [];
  @override
  Widget build(BuildContext context) {
    var controller = ScrollController();
    controller.addListener(() async {
      //print("called add listener");
      if(controller.position.pixels == controller.position.maxScrollExtent) {
        // add item?        
        print("=====================");
        contents.addAll(await widget.client.getData());
        setState(() {
          
        });
      }
    });
    return FutureBuilder(
      future: this.widget.client.getData(),
      builder: (context, snapshot) {
        print("-------- ${contents.length}");
        if(snapshot.hasData) {
          contents.addAll(snapshot.data);
          return GridView.count(
            children: contents.map((e) => widget.client.createWidget(e)).toList(),
            crossAxisCount: this.widget.crossAxisCount,
            controller: controller,
            );
        }else {
          return Container(child: Text('...loading'),); 
        }
      },
    );
    
    

  }
}
