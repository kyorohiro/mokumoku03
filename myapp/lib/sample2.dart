import 'package:flutter/material.dart';
// https://stackoverflow.com/questions/51069712/how-to-know-if-a-widget-is-visible-within-a-viewport

main( ) {
  runApp(
    MaterialApp(
      home:  Scaffold(
        appBar: AppBar(title: Text("Sample"),),
        body: DynamiCGridView(MyDynamicGridViewClient())
      )
    )
  );
}

class MyDynamicGridViewClient extends  DynamicGridViewClient<String> {
    int i=0;
  Future<List<String>> getData() async {
    return List<String>.generate(100, (index) => "ZZ:${i++}");
  }
  Widget createWidget(String v) {
    return Container(child: Text(v),);
  }
}

abstract class DynamicGridViewClient<X> {
  Future<List<X>> getData();
  Widget createWidget(X v);
}

//DynamicGridViewClient client = new  DynamicGridViewClient();

class DynamiCGridView extends StatefulWidget {
  DynamicGridViewClient client;
  DynamiCGridView(this.client);
  @override
  _DynamiCGridViewState createState() => _DynamiCGridViewState();
}

class _DynamiCGridViewState extends State<DynamiCGridView> {
  List<String> contents = List.generate(30, (index) => "${index}").toList();
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
    return GridView.count(
      children: contents.map((e) => widget.client.createWidget(e)).toList(),
      crossAxisCount: 3,
      controller: controller,
      );
    //return Center(child: Text("Hello, World!!"),);
  }
}
