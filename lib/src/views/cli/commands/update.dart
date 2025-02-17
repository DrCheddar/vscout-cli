import 'package:args/command_runner.dart';

import 'package:vscout/vscout_cli.dart' show VscoutCommand;

import 'update/data.dart';
import 'update/attribute.dart';

class UpdateCommand extends Command {
  @override
  String get name => 'update';

  @override
  String get description => 'Update data or attributes from the database';

  UpdateCommand() {
    addSubcommand(DataCommand());
    addSubcommand(AttributeCommand());
  }
  @override
  run() async {}
}
