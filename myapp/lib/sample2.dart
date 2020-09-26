import 'package:flutter/material.dart';

main( ) {
  runApp(
    MaterialApp(
      home:  Scaffold(
        appBar: AppBar(title: Text("Sample"),),
        body: DynamiCGridView()
      )
    )
  );
}

class DynamicGridViewClient {
  int i=0;
  Future<List<String>> getData() async {
    return List<String>.generate(100, (index) => "XX:${i++}");
  }
}

DynamicGridViewClient client = new  DynamicGridViewClient();

class DynamiCGridView extends StatefulWidget {
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
        contents.addAll(await client.getData());
        setState(() {
          
        });
      }
    });
    return GridView.count(
      children: contents.map((e) => Container(child: Text(e),)).toList(),
      crossAxisCount: 3,
      controller: controller,
      );
    //return Center(child: Text("Hello, World!!"),);
  }
}
