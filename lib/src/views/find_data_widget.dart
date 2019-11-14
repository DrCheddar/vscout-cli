import 'package:flutter/material.dart';
import '../widgets/banner_widget.dart';
import '../widgets/validator_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/button_widget.dart';
import 'package:vscout/view_models.dart' show FindDataVM, ViewModel, AddDataVM;
import 'package:vscout/transfer.dart';
import 'package:tuple/tuple.dart';
import './add_data_view.dart';


class FindDataWidget extends StatelessWidget with MainBodyWidget {
  final _findDataVM = FindDataVM();
  @override 
  FloatingActionButton floatButton() => null;
  @override 
  Widget build(BuildContext context) {
    return makeSearchBody();
  }
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
}