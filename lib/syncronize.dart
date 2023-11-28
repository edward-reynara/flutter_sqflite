import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'databasehelper.dart';
import 'contactinfomodel.dart';
import 'package:http/http.dart' as htpp;

class SyncronizationData {

  static Future<bool> isInternet()async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (await DataConnectionChecker().hasConnection) {
        print("Mobile data detected & internet connection confirmed.");
        return true;
      }else{
        print('No internet :( Reason:');
        return false;
      }
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (await DataConnectionChecker().hasConnection) {
        print("wifi data detected & internet connection confirmed.");
        return true;
      }else{
        print('No internet :( Reason:');
        return false;
      }
    }else {
      print("Neither mobile data or WIFI detected, not internet connection found.");
      return false;
    }
  }

  final conn = SqfliteDatabaseHelper.instance;
  
  Future<List<ContactinfoModel>> fetchAllInfo()async{
    final dbClient = await conn.db;
    List<ContactinfoModel> contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.contactinfoTable);
      for (var item in maps) {
        contactList.add(ContactinfoModel.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysqlWith(List<ContactinfoModel> contactList)async{
    print("saveToMysqlWith");
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "name":contactList[i].name,
      };
      print(data);
      final response = await htpp.post(Uri.parse('https://forintfnpapps.forisa.co.id:8707/api/product/create'), body: data);
      print(response);
      if (response.statusCode==200) {
        print("Saving Data");
      }else{
        print(response.statusCode);
      }
    }
  }

  Future<List> fetchAllCustoemrInfo()async{
    final dbClient = await conn.db;
    List contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.contactinfoTable);
      for (var item in maps) {
        contactList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysql(List contactList)async{
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "name":contactList[i]['name'],
      };
      final response = await htpp.post(Uri.parse('https://forintfnpapps.forisa.co.id:8707/api/product/create'),body: data);
      if (response.statusCode==200) {
        print("Saving Data ");
      }else{
        print(response.statusCode);
      }
    }
  }

}