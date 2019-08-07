import 'package:args/command_runner.dart';
import '../../utils/utils.dart';

class DataCommand extends Command {
  @override
  String get name => 'data';
  @override
  String get description => 'Update data to the database';

  DataCommand() {
    argParser..addFlag('verbose', defaultsTo: false);
  }

  @override
  run() async {
    //TODO: Replace with actual command.
    Map properties = parseArgsJson(argResults.rest[0]);
    print(properties);
    if (argResults['verbose'] == true) {}
  }
}