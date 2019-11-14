import 'package:flutter/material.dart';
import '../widgets/banner_widget.dart';
import '../widgets/validator_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/button_widget.dart';
import 'package:vscout/view_models.dart' show FindDataVM, ViewModel, AddDataVM;
import 'package:vscout/transfer.dart';
import 'package:tuple/tuple.dart';
import './add_data_view.dart';
import './find_data_widget.dart';
class VscoutListView extends StatefulWidget {
  VscoutListView({Key key, this.title}) : super(key: key);
  final String title;
  @override
  VscoutListViewState createState() {
    VscoutListViewState viewState = VscoutListViewState();
    return viewState;
  }
}

class VscoutListViewState extends State<VscoutListView> {
  ViewModel _findDataVM;
  ViewModel _addDataVM;
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  List<Widget> _children = [FindDataWidget(), AddDataWidget()];
  VscoutListViewState() {
    _findDataVM = FindDataVM();
    _addDataVM = AddDataVM();
  }

  Container makeBottom() => Container(
        height: 55.0,
        child: BottomAppBar(
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: BottomNavigationBar(
            fixedColor: Color.fromRGBO(58, 66, 86, 1.0),
            onTap: onTabTapped, // new
            currentIndex: _currentIndex,
            items: [
              new BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
                backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                title: Text('Messages'),
                backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              ),
              new BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
              )
            ],
          ),
        ),
      );
  final topAppBar = AppBar(
    elevation: 0.1,
    backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    title: Text("Vscout"),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.list),
        onPressed: () {},
      )
    ],
  );

  int _currentIndex = 0;
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: _children[_currentIndex],    // makeListBody([{}]),
      // SingleChildScrollView(
      //   child: SafeArea(
      //     child: _children[_currentIndex],)),
      bottomNavigationBar: makeBottom(),
      floatingActionButton: _children.cast<MainBodyWidget>()[_currentIndex].floatButton()?? null,
    );
  }
}
