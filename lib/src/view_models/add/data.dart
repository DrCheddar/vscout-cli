part of vscout.view_models;

class AddDataVM extends ViewModel {
  @override
  void handleInputData(input) async {
    // TODO: Instead of using a Map as the data, create a QUERY object similar to RESPONSE that is holds parameters and data
    if (input.method == 'data') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(this.addData(input));
    } else if (input.method == 'file') {
      input.setCallback((data) {
        this.outputController.add(data);
      });
      input.recieveResponse(this.addCsv(input));
    }
  }

  Future<Response> addData(Request data) async {
    Response resultResponse =
        await this.databaseHandler.addEntry(data.optionArgs);
    this.result = resultResponse;
    return this.result;
  }

  Future<Response> addCsv(Request data) async {
    List<Map> csv = parseCsv(data.options['csv']);
    List<Response> responseList = List();
    for (Map entry in csv) {
      List<Tuple2> optionArgs = data.optionArgs;
      optionArgs.add(Tuple2("data", [entry]));
      responseList.add(await this.databaseHandler.addEntry(optionArgs));
    }
    this.result = responseList[0];
    for (Response response in responseList.sublist(1)) {
      this.result.joinResponse(response);
    }
    return this.result;
  }

  List<Map<String, dynamic>> parseCsv(String csvPath) {
    List<List> csv = CsvToListConverter()
        .convert(File(csvPath).readAsStringSync(), eol: '\n');
    List<Map<String, dynamic>> list = List();
    List<String> fields = csv[0].cast<String>();

    print(fields.length);
    for (List values in csv.sublist(1)) {
      list.add(Map<String, dynamic>.fromIterables(fields, values));
    }
    return list;
  }

  Future<Response> addStringData(String dataEntry) async {
    Map properties = parseArgsJson(dataEntry);
    await this.addMapData(properties);
    this.result.statusCheck(dataEntry, 'ADD/DATA/STRING');
    return this.result;
  }

  Future<Response> addMapData(Map dataEntry) async {
    // this.result = await this.databaseHandler.addEntry(dataEntry);
    this.result.statusCheck(dataEntry.toString(), 'ADD/DATA/MAP');
    return this.result;
  }

  Future addFileData(String relativeFilePath) async {
    String fileFolder = '/../files/';
    //  Tries to find file in [files] folder.
    var absFilePath =
        ("${dirname(Platform.script.toFilePath()).toString()}$fileFolder$relativeFilePath");
    final inputFile = new File(absFilePath);
    String fileContents;
    fileContents = await inputFile.readAsString();
    //  Decode file contents as JSON.
    Map baseMap = json.decode(fileContents);
    // Remove trailing white space, convert inputs to string to allow for staticly typed Dart methods.
    Map properties = Map<String, String>();
    baseMap.forEach((k, v) =>
        properties[k is String ? k.trim() : k.toString().trim()] =
            v is String ? v.trim() : v.toString().trim());
    await this.addMapData(properties);
    this.result.statusCheck(relativeFilePath, 'ADD/DATA/FILE');
    return this.result;
  }

  Future addCsvData(String relativeFilePath) async {
    String fileFolder = '/../files/';
    //  Tries to find file in [files] folder.
    var absFilePath =
        ("${dirname(Platform.script.toFilePath()).toString()}$fileFolder$relativeFilePath");
    final inputFile = new File(absFilePath);
    String fileContents;
    fileContents = await inputFile.readAsString();
    //  Decode file contents as JSON.
    Map baseMap = json.decode(fileContents);
    // Remove trailing white space, convert inputs to string to allow for staticly typed Dart methods.
    Map properties = Map<String, String>();
    baseMap.forEach((k, v) =>
        properties[k is String ? k.trim() : k.toString().trim()] =
            v is String ? v.trim() : v.toString().trim());
    await this.addMapData(properties);
    this.result.statusCheck(relativeFilePath, 'ADD/DATA/FILE');
    return this.result;
  }
}
