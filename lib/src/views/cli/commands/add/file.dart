import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show AddDataVM;

//TODO: This is broken right now because the input stream will default to parse input as string.
//TODO: Need to fix this by creating QUERY class, which will specify FILE or STRING for example.

class FileCommand extends Command with VscoutCommand {
  @override
  String get name => 'file';
  @override
  String get description => 'Add entry to the database through JSON File';
  FileCommand() {
    argParser
      ..addFlag('verbose', defaultsTo: false)
      ..addOption('csv')
      ..addMultiOption('metadata', abbr: 'm', splitCommas: true);
    this.viewModel = AddDataVM();
    this.initializeStream();
  }

  @override
  void handleResponse(data) {
    print('Added entries: \n \n');
    this.results = data;
    this.printResponse(argResults['verbose']);
    this.streamSubscription.pause();
  }

  @override
  run() async {
    this.parseArguments();
    this.streamSubscription.resume();
    viewModel.inputController.add(this.request);
  }
}
