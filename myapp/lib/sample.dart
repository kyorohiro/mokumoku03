//
// ref https://stackoverflow.com/questions/61707587/what-is-best-practices-for-implement-a-infinite-scroll-gridview-in-flutter

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


void main() {
  runApp(
    MaterialApp(
        title: 'Gridview',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Color(0xFFFEF9EB),
        ),
        home: HomeScreen()
    ));
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  List dataList = new List<int>();
  bool isLoading = false;
  int pageCount = 1;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    ////LOADING FIRST  DATA
    addItemIntoLisT(1);

    _scrollController = new ScrollController(initialScrollOffset: 5.0)
      ..addListener(_scrollListener);
  }

  Widget build(BuildContext context) {
    print("..${dataList.length}");
    return  Scaffold(
            appBar: new AppBar(),
            body: GridView.count(
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,

              physics: const AlwaysScrollableScrollPhysics(),
              children: dataList.map((value) {
                return Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text("Item ${value}"),
                    );


              }).toList(),
            )
    );
  }

  //// ADDING THE SCROLL LISTINER
  _scrollListener() {
    print("_scrollListener");
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        print("comes to bottom $isLoading");
        isLoading = true;

        if (isLoading) {
          print("RUNNING LOAD MORE");

          pageCount = pageCount + 1;

          addItemIntoLisT(pageCount);
        }
      });
    }
  }

  ////ADDING DATA INTO ARRAYLIST
  void addItemIntoLisT(var pageCount) {
    for (int i = (pageCount * 10) - 10; i < pageCount * 10; i++) {
      dataList.add(i);
      isLoading = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
