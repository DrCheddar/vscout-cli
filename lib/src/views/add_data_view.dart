import 'package:flutter/material.dart';
import '../widgets/banner_widget.dart';
import '../widgets/validator_widget.dart';
import '../widgets/text_field_widget.dart';
import '../widgets/button_widget.dart';
import 'package:vscout/view_models.dart' show FindDataVM, ViewModel, AddDataVM;
import 'package:vscout/transfer.dart';
import 'package:tuple/tuple.dart';

mixin MainBodyWidget{
  FloatingActionButton floatButton();
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
  FloatingActionButton floatButton() => mainState.floatButton();
}
class AddDataState extends State<AddDataWidget> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<AddDataWidget>.
  final _formKey = GlobalKey<FormState>();
  final _addDataVM = AddDataVM();
  FloatingActionButton floatButton() => FloatingActionButton(
    child: Icon(Icons.add),
    onPressed: () {
      
      setState(() {
        inputFields.add(TextPair());

      });
    }
  );
  final List<TextPair> inputFields =[TextPair()];
 
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
      
        child: Column(
          children: <Widget>[
            Expanded(child: ListView.builder(
              itemBuilder: (BuildContext context, int index) => inputFields[index],
              itemCount: inputFields.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            )),
            ButtonWidget(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                Request _request = Request("data");
                for(var textPair in inputFields) {
                  _request.optionArgs.add(Tuple2("data", textPair.value ));
                }
                _addDataVM.inputController.add(_request);
              },
              buttonText: "Let's go",
            ), 
            
            SizedBox(height: 48.0),
          ],
        )// Build this out in the next steps.
    ));
  }
}
class TextPair extends StatelessWidget {
  final keyField = InputFieldWidget(
              fieldType: "text",
              hintText: "Key:",
              labelText: "Key",
              textController: TextEditingController(),
              prefixIcon: Icon(Icons.vpn_key));
  final valueField = InputFieldWidget(
              fieldType: "text",
              hintText: "Value:",
              labelText: "Value", 
              textController: TextEditingController(),
              prefixIcon: Icon(Icons.view_carousel));

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      keyField,
      valueField
    ],);
  }
  List get value => [keyField.text, valueField.text];
}

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget(
      {this.fieldType,
      this.hintText,
      this.labelText,
      this.prefixIcon,
      this.validator,
      this.textController
      });
  final String fieldType;
  final String hintText;
  final String labelText;
  final Icon prefixIcon;
  final FormFieldValidator validator;
  String get text => textController.text;
  final TextEditingController textController;

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
      SizedBox(height: 20.0),
     
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
