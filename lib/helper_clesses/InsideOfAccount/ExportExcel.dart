import 'dart:io';
import 'dart:typed_data';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projects/Singleton/SingletonUserInformation.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportExcel {
  Future<String> export() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // the downloads folder path

    // ByteData data = await rootBundle.load("assets/file_example_XLSX_1000.xlsx");
    // var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.createExcel();
    // or
    //var excel = Excel.decodeBytes(bytes);
    String _emailOrPhone;
    DateTime _date;
    String _nameOfTransport;
    String _marka;
    String _model;
    String _yearOfMade;
    String _yearOfPurchase;
    int _numberOfTank;
    String _firstTankType;
    int _firstTankVolume;
    String _secondTankType;
    int _secondTankVolume;
    String _number;
    double _run;
    String _techPassport;
    double _initialRun;
    bool _proAccount;
    double _average = 0;
    excel.rename("Sheet1", "AutoApp");

    var sheet = excel['AutoApp'];
    sheet.appendRow(
        ["Название транспорта", SingletonUserInformation().nameOfTransport]);
    sheet.appendRow(["Mарка", SingletonUserInformation().marka]);
    sheet.appendRow(["Модель", SingletonUserInformation().model]);
    sheet
        .appendRow(["Год производства", SingletonUserInformation().yearOfMade]);
    sheet.appendRow(["Год покупки", SingletonUserInformation().yearOfPurchase]);
    sheet.appendRow(["Тип", SingletonUserInformation().firstTankType]);
    sheet.appendRow(["Обьем", SingletonUserInformation().firstTankVolume]);
    if (SingletonUserInformation().numberOfTank == 2) {
      sheet.appendRow(["Тип", SingletonUserInformation().secondTankType]);
      sheet.appendRow(["Обьем", SingletonUserInformation().secondTankVolume]);
    }
    sheet.appendRow(["Номер", SingletonUserInformation().number]);
    sheet.appendRow(["Тех Паспорт", SingletonUserInformation().techPassport]);
    sheet.appendRow(["Средний пробег", SingletonUserInformation().average]);
    sheet.appendRow(["Пробег", SingletonUserInformation().run]);
    sheet.appendRow([
      "Расходы в этом месяце",
      SingletonUserInformation().expenses.in_this_month
    ]);
    sheet.appendRow(
        ["Расходы за все время", SingletonUserInformation().expenses.all_time]);

    print(sheet.rows);

    // var cell = sheet.cell(CellIndex.indexByString("A"));
    // cell.value = "Heya How are you I am fine ok goood night";
    // cell.cellStyle = cellStyle;
    //
    // var cell2 = sheet.cell(CellIndex.indexByString("B"));
    // cell2.value = "Heya How night";
    // cell2.cellStyle = cellStyle;
    //
    // /// printing cell-type
    // print("CellType: " + cell.cellType.toString());
    //
    // /// Iterating and changing values to desired type
    // for (int row = 0; row < sheet.maxRows; row++) {
    //   sheet.row(row).forEach((cell) {
    //     var val = cell.value; //  Value stored in the particular cell
    //
    //     cell.value = ' My custom Value ';
    //   });
    // }
    //
    // //
    // //
    // // // fromSheet should exist in order to sucessfully copy the contents
    // // excel.copy('myRenamedNewSheet', 'toSheet');
    // //
    // // excel.rename('oldSheetName', 'newSheetName');
    // //
    // // excel.delete('Sheet1');
    // //
    // // excel.unLink('sheet1');
    //
    // sheet = excel['Sheet1'];
    //
    // /// appending rows
    // List<List<String>> list = List.generate(
    //     6000, (index) => List.generate(20, (index1) => '$index $index1'));
    //
    // Stopwatch stopwatch = new Stopwatch()..start();
    // list.forEach((row) {
    //   sheet.appendRow(row);
    // });
    //
    // print('doSomething() executed in ${stopwatch.elapsed}');
    //
    // sheet.appendRow([8]);
    // excel.setDefaultSheet(sheet.sheetName).then((isSet) {
    //   // isSet is bool which tells that whether the setting of default sheet is successful or not.
    //   if (isSet) {
    //     print("${sheet.sheetName} is set to default sheet.");
    //   } else {
    //     print("Unable to set ${sheet.sheetName} to default sheet.");
    //   }
    // });

    // Saving the file

    Directory tempDir =
        await DownloadsPathProvider.downloadsDirectory;
    String appDocPath = tempDir.path;
    String pathOfFile = appDocPath.split("/").last;
    print(appDocPath);
    File(join(appDocPath, "autoapp.xlsx"))
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode());
    return pathOfFile;
  }
}
