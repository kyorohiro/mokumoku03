import 'package:flutter/material.dart';

//
// TODO 
// This widget expect  
//   - get many data at first client.getData()  
//
abstract class DynamicGridViewClient<X> {
  Future<List<X>> getData();
  Widget createWidget(BuildContext context, X v);
}

class SampleDynamicGridViewClient extends  DynamicGridViewClient<String> {
    int i=0;
  Future<List<String>> getData() async {
    return List<String>.generate(100, (index) => "ZZ:${i++}");
  }
  Widget createWidget(BuildContext context, String v) {
    return Container(child: Text(v),);
  }
}


class DynamicGridView extends StatefulWidget {
  final DynamicGridViewClient client;
  final int crossAxisCount;
  DynamicGridView(this.client, this.crossAxisCount, {Key key}):super(key: key);
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
        var dat = await widget.client.getData();
        print("== ${dat.length}");
        contents.addAll(dat);
        setState(() {
          
        });
      }
    });
    // todo :this future build paet is wront
    return FutureBuilder(
      future: this.widget.client.getData(),
      builder: (context, snapshot) {        
        if(snapshot.hasData) {
          contents.addAll(snapshot.data);
          var gridView =  GridView.count(
            children: contents.map((e) => widget.client.createWidget(context, e)).toList(),
            crossAxisCount: this.widget.crossAxisCount,
            controller: controller,
            );

            return Column(
              children: [
                Expanded(child:gridView),
                /*
                Container(
                  height: 80,
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(0.0),
                  color: Colors.white,
                  child: RaisedButton(
                    child: Container(                                        
                      width: double.infinity,
                      height: 80,
                      alignment: Alignment.center,
                      //color: Colors.white,
                      decoration: BoxDecoration(                        
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(width: 1.0),
                        color: Colors.white
                      ),
                      child:  Text("More"),)
                  ))
                  */
              ],
            );
        }else {
          return Container(child: Text('...loading'),); 
        }
      },
    );
    
    

  }
}
