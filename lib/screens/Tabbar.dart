import 'package:flutter/material.dart';

class Tabbar extends StatefulWidget {
  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.category),
              ),
              Tab(
                icon: Icon(Icons.star),
              ),
            ],
          ),
        ),
        //Body By Tabs order
        body: TabBarView(children: [
          //Screen1
          //Screen2
        ]),
        //drawer
      ),
    );
  }
}
