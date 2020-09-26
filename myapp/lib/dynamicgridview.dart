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

//DynamicGridViewClient client = new  DynamicGridViewClient();

class DynamicGridView extends StatefulWidget {
  DynamicGridViewClient client;
  DynamicGridView(this.client);
  @override
  _DynamicGridViewState createState() => _DynamicGridViewState();
}

class _DynamicGridViewState extends State<DynamicGridView> {
  List contents = [];
  @override
  Widget build(BuildContext context) {
    var controller = ScrollController();
    controller.addListener(() async {
      print("called add listener");
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
            crossAxisCount: 3,
            controller: controller,
            );
        }else {
          return Container(child: Text('...loading'),); 
        }
      },
    );
    
    

  }
}
