import 'package:flutter/material.dart';
import '../widgets/banner_widget.dart';
import '../widgets/validator_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/button_widget.dart';
import 'package:vscout/view_models.dart' show FindDataVM, ViewModel, AddDataVM;
import 'package:vscout/transfer.dart';
import 'package:tuple/tuple.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

mixin MainBodyWidget {
  Widget floatButton();
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddDataWidget extends StatefulWidget with MainBodyWidget {
  AddDataState mainState = AddDataState();
  @override
  createState() {
    mainState = AddDataState();
    return mainState;
  }

  @override
  Widget floatButton() => SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        // visible: _dialVisible,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.done),
              backgroundColor: Colors.red,
              label: 'Save',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('FIRST CHILD')),
          SpeedDialChild(
              child: Icon(Icons.short_text),
              backgroundColor: Colors.blue,
              label: 'Text',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                mainState.setState(() {
                  mainState.inputFields.add(InputField.shortText());
                });
              }),
          SpeedDialChild(
            child: Icon(Icons.score),
            backgroundColor: Colors.green,
            label: 'Value',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              mainState.setState(() {
                mainState.inputFields.add(InputField.number());
              });
            },
          ),
          SpeedDialChild(
              child: Icon(Icons.star),
              backgroundColor: Colors.orange,
              label: 'Rating',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => mainState.setState(() {
                    mainState.inputFields.add(InputField.star());
                  })),
          SpeedDialChild(
            child: Icon(Icons.list),
            backgroundColor: Colors.purple,
            label: 'List',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('THIRD CHILD'),
          ),
        ],
      );
}

class AddDataState extends State<AddDataWidget> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<AddDataWidget>.
  final _formKey = GlobalKey<FormState>();
  final _addDataVM = AddDataVM();
  @override
  void dispose() {
    inputFields.forEach((var field) => field.dispose());
    print(this);
    super.dispose();
  }

  // Icon(Icons.add),
  // onPressed: () {

  // setState(() {
  //   inputFields.add(ShortTextField());

  // });
  // }

  final List<InputField> inputFields = [ShortTextField()];

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      inputFields[index],
                  itemCount: inputFields.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                )),
              ],
            ) // Build this out in the next steps.
            ));
  }
}

abstract class InputField extends StatelessWidget {
  List get value;
  Widget get keyField;
  Widget get valueField;
  InputField();

  factory InputField.shortText() => ShortTextField();
  factory InputField.number() => NumberField();
  factory InputField.star() => StarField();

  void dispose();
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: 10.0),
      Row(children: <Widget>[
        Expanded(child: Divider(thickness: 2, color: Colors.white, indent: 5, endIndent: 5,)),
        Text("OR"),
        Expanded(child: Divider(thickness: 2, color: Colors.white, indent: 5, endIndent: 5,)),
      ]),
      keyField,
      valueField, 
      SizedBox(height: 10.0),
    ], );
  }
}

class ShortTextField extends InputField {
  final TextInputWidget keyField = TextInputWidget(
      fieldType: "text",
      hintText: "Key:",
      labelText: "Key",
      textController: TextEditingController(),
      prefixIcon: Icon(Icons.vpn_key));
  final TextInputWidget valueField = TextInputWidget(
      fieldType: "text",
      hintText: "Value:",
      labelText: "Value",
      textController: TextEditingController(),
      prefixIcon: Icon(Icons.view_carousel));
  @override
  void dispose() {
    keyField.dispose();
    valueField.dispose();
  }

  @override
  List get value => [keyField.text, valueField.text];
}

class NumberField extends InputField {
  final TextInputWidget keyField = TextInputWidget(
      fieldType: "text",
      hintText: "Key:",
      labelText: "Key",
      textController: TextEditingController(),
      prefixIcon: Icon(Icons.vpn_key));
  final TextInputWidget valueField = TextInputWidget(
      fieldType: "number",
      hintText: "Value:",
      labelText: "Value",
      textController: TextEditingController(),
      prefixIcon: Icon(Icons.view_carousel));
  @override
  void dispose() {
    keyField.dispose();
    valueField.dispose();
  }

  @override
  List get value => [keyField.text, valueField.text];
}

class StarField extends InputField {
  final StarWidget valueField = StarWidget();
  final TextInputWidget keyField = TextInputWidget(
      fieldType: "text",
      hintText: "Key:",
      labelText: "Key",
      textController: TextEditingController(),
      prefixIcon: Icon(Icons.vpn_key));

  @override
  void dispose() {
    keyField.dispose();
  }

  @override
  List get value => [keyField.text, valueField.value];
}

class TextInputWidget extends StatelessWidget {
  const TextInputWidget(
      {this.fieldType,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      this.validator,
      this.textController});
  final String fieldType;
  final String hintText;
  final String labelText;
  final Icon prefixIcon;
  final FormFieldValidator validator;
  String get text => textController.text;
  final TextEditingController textController;
  void dispose() {
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool obscureText;
    TextInputType keyboardType;

    if (fieldType == "password") {
      obscureText = true;
      keyboardType = TextInputType.text;
    } else if (fieldType == "email") {
      obscureText = false;
      keyboardType = TextInputType.emailAddress;
    } else if (fieldType == "number") {
      obscureText = false;
      keyboardType = TextInputType.number;
    } else {
      obscureText = false;
      keyboardType = TextInputType.text;
    }

    final contentPadding =
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0);

    TextStyle fieldStyle = TextStyle(fontSize: 18.0);

    TextStyle labelStyle = TextStyle(
        fontFamily: 'Proxima Nova', fontSize: 16.0, color: Colors.grey);

    final textField =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      SizedBox(height: 10.0),
      TextFormField(
          obscureText: obscureText,
          style: fieldStyle,
          keyboardType: keyboardType,
          validator: validator,
          controller: textController,
          decoration: InputDecoration(
            contentPadding: contentPadding,
            hintText: hintText,
            prefixIcon: prefixIcon,
            fillColor: Colors.white,
            filled: true,
          ))
    ]);

    return Container(child: textField);
  }
}

class StarWidget extends StatefulWidget {
  StarState currentState = StarState();
  @override
  StarState createState() {
    currentState = StarState();
    return currentState;
  }

  double get value => currentState.value;
}

class StarState extends State<StarWidget> {
  final starWatcher = ValueNotifier<double>(3);
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: 20.0),
      SmoothStarRating(
          allowHalfRating: true,
          onRatingChanged: (v) {
            setState(() => starWatcher.value = v);
          },
          starCount: 5,
          rating: starWatcher.value,
          size: 40.0,
          color: Colors.green,
          borderColor: Colors.green,
          spacing: 0.0)
    ]);
  }

  double get value => starWatcher.value;
}
