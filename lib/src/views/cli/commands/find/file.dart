import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'package:vscout/view_models.dart' show FindDataVM;

//TODO: This is broken right now because the input stream will default to parse input as string.
//TODO: Need to fix this by creating QUERY class, which will specify FILE or STRING for example.
class FileCommand extends Command with VscoutCommand {
  @override
  String get name => 'file';
  @override
  String get description => 'Find entries in the database through JSON File';

  FileCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }
  @override
  void handleResponse(data) {}
  @override
  run() async {
    final FindDataVM addDataModel = new FindDataVM();
    this.results = await addDataModel.findFileData(argResults.rest[0]);
    print('Entries found \n \n');
    return this.printResponse(argResults['verbose']);
  }
}
