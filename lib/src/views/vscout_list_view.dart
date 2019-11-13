import 'package:flutter/material.dart';
import '../widgets/banner_widget.dart';
import '../widgets/validator_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/button_widget.dart';
import 'package:vscout/view_models.dart' show FindDataVM, ViewModel, AddDataVM;
import 'package:vscout/transfer.dart';
import 'package:tuple/tuple.dart';

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
  final _formKey = GlobalKey<FormState>();
  ViewModel _findDataVM;
  ViewModel _addDataVM;
  final _request = Request("data");
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> _children;
  VscoutListViewState() {
    _findDataVM = FindDataVM();
    _addDataVM = AddDataVM();

    _children = [makeSearchBody(), makeInputBody()];
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

  Card customCard(int index, Map data) => Card(
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: customTile(index, data),
        ),
      );
  ListTile customTile(int index, Map data) => ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.autorenew, color: Colors.white),
      ),
      title: Text(
        data["key"],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Icon(Icons.linear_scale, color: Colors.yellowAccent),
          Text(" Intermediate", style: TextStyle(color: Colors.white))
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
  TextEditingController editingController = TextEditingController();

  Widget makeSearchBody() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (value) {
            final request = Request("data");
            if (value.isNotEmpty) {
              request.optionArgs = [
                Tuple2<String, List>("create", ["team", "IN", value])
              ];
              request.args = [
                ["team", "IN", value]
              ];
            } else {
              request.optionArgs = [
                Tuple2<String, List>(
                    "create", ["metadata.type", "NOT", "match"])
              ];
              request.args = [
                ["metadata.type", "NOT", "match"]
              ];
            }

            _findDataVM.inputController.add(request);
          },
          controller: editingController,
          decoration: InputDecoration(
              focusColor: Colors.white,
              labelText: "Search",
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
        ),
      ),
      Expanded(
          child: StreamBuilder<Response>(
        stream: _findDataVM.outputController.stream,
        builder: (context, snapshot) => makeListBody(snapshot.data?.data),
      ))
    ]);
  }

  Widget makeListBody(List<Map> entries) {
    if (entries == null) {
      final _request = Request("data");
      _request.optionArgs = [
        Tuple2<String, List>("create", ["metadata.type", "NOT", "match"])
      ];
      _request.args = [
        ["metadata.type", "NOT", "match"]
      ];
      _findDataVM.inputController.add(_request);
      return ListView();
    }
    return ListView.custom(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      childrenDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
        return customCard(index, entries[index]);
      },
      childCount: entries.length),
    );
  }

  Container makeInputBody() {
    String key, value;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 48.0),
        child: Column(
          children: <Widget>[
            TextFieldWidget(
              onChanged: (String textValue) => key = textValue,
              fieldType: "text",
              hintText: "Team:",
              labelText: "Key",
              prefixIcon: Icon(Icons.flag),
            ),
            TextFieldWidget(
              onChanged: (String textValue) => value = textValue,
              fieldType: "text",
              hintText: "2381C",
              labelText: "Value",
              prefixIcon: Icon(Icons.supervisor_account),
            ),
            ButtonWidget(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                Request _request = Request("data");
                _request.args = [
                  [key, value]
                ];
                _request.optionArgs = [
                  Tuple2("data", [key, value]),
                ];
                _addDataVM.inputController.add(_request);
              },
              buttonText: "Let's go",
            ),
            SizedBox(height: 48.0),
          ],
        ));
  }

  int _currentIndex = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: 
      // makeListBody([{}]),
      _children[_currentIndex],

      // SingleChildScrollView(
      //   child: SafeArea(
      //     child: _children[_currentIndex],)),
      bottomNavigationBar: makeBottom(),
    );
  }
}

Widget _myListView(BuildContext context) {
  return ListView(
    children: <Widget>[
      ListTile(
        title: Text('Sun'),
      ),
      ListTile(
        title: Text('Moon'),
      ),
      ListTile(
        title: Text('Star'),
      ),
    ],
  );
}
