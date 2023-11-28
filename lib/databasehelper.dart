import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseHelper {

  SqfliteDatabaseHelper.internal();
  static final SqfliteDatabaseHelper instance = new SqfliteDatabaseHelper.internal();
  factory SqfliteDatabaseHelper() => instance;

  static final contactinfoTable = 'contactinfoTable';
  static final _version = 1;

  static Database _db;

  Future<Database> get db async {
    if (_db !=null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb()async{
    await _checkStoragePermissions();

    // Create the directory
    // Directory externalStorage = await getExternalStorageDirectory();
    final externalStorage = Directory('/storage/emulated/0');
    final edoPath = join(externalStorage.path, 'edo');

    // Check if the directory exists
    if (!(await Directory(edoPath).exists())) {
      // Create the directory if it doesn't exist
      await Directory(edoPath).create(recursive: true);

      print('Edo directory created at: $edoPath');
    }

    ////
    String dbPath = join(edoPath,'syncdatabase.db');
    print("dbPath");
    print(dbPath);
    var openDb = await openDatabase(dbPath,version: _version,
    onCreate: (Database db,int version)async{
      await db.execute("""
        CREATE TABLE $contactinfoTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT, 
          created_at TEXT
          )""");
    },
    onUpgrade: (Database db, int oldversion,int newversion)async{
      if (oldversion<newversion) {
        print("Version Upgrade");
      }
    }
    );
    print('db initialize');
    return openDb;
  }

  Future<void> _checkStoragePermissions() async {
    // Check if the user has granted the WRITE_EXTERNAL_STORAGE permission.
    final writePermission = await Permission.storage.status;
    if (writePermission.isDenied) {
      // Request the WRITE_EXTERNAL_STORAGE permission.
      final status = await Permission.storage.request();
      if (status.isGranted) {
        // Permission granted, proceed with the operation.
        print('Write permission granted');
      } else if (status.isPermanentlyDenied) {
        // User has permanently denied the permission, show a message.
        print('Write permission permanently denied');
        openAppSettings();
      } else {
        // Permission denied, show a message.
        print('Write permission denied');
      }
    } else {
      // Permission already granted, proceed with the operation.
      print('Write permission already granted');
    }

    // Check if the user has granted the READ_EXTERNAL_STORAGE permission.
    final readPermission = await Permission.accessMediaLocation.status;
    if (readPermission.isDenied) {
      // Request the READ_EXTERNAL_STORAGE permission.
      final status = await Permission.accessMediaLocation.request();
      if (status.isGranted) {
        // Permission granted, proceed with the operation.
        print('Read permission granted');
      } else if (status.isPermanentlyDenied) {
        // User has permanently denied the permission, show a message.
        print('Read permission permanently denied');
        openAppSettings();
      } else {
        // Permission denied, show a message.
        print('Read permission denied');
      }
    } else {
      // Permission already granted, proceed with the operation.
      print('Read permission already granted');
    }

    // Check2
    final readPermission2 = await Permission.mediaLibrary.status;
    if (readPermission2.isDenied) {
      // Request the READ_EXTERNAL_STORAGE permission.
      final status = await Permission.mediaLibrary.request();
      if (status.isGranted) {
        // Permission granted, proceed with the operation.
        print('Read permission granted');
      } else if (status.isPermanentlyDenied) {
        // User has permanently denied the permission, show a message.
        print('Read permission permanently denied');
        openAppSettings();
      } else {
        // Permission denied, show a message.
        print('Read permission denied');
      }
    } else {
      // Permission already granted, proceed with the operation.
      print('Read permission already granted');
    }

    // Check3
    final readPermission3 = await Permission.manageExternalStorage.status;
    if (readPermission3.isDenied) {
      // Request the READ_EXTERNAL_STORAGE permission.
      final status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        // Permission granted, proceed with the operation.
        print('Read permission granted');
      } else if (status.isPermanentlyDenied) {
        // User has permanently denied the permission, show a message.
        print('Read permission permanently denied');
        openAppSettings();
      } else {
        // Permission denied, show a message.
        print('Read permission denied');
      }
    } else {
      // Permission already granted, proceed with the operation.
      print('Read permission already granted');
    }
  }
}