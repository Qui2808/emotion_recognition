import 'package:facial_emotions/models/myobject.dart';
import 'package:objectbox/objectbox.dart';
import 'package:facial_emotions/objectbox.g.dart';

class ObjectBoxManager {
  late Store _store;

  // Singleton pattern
  static final ObjectBoxManager _instance = ObjectBoxManager._internal();

  factory ObjectBoxManager() {
    return _instance;
  }

  ObjectBoxManager._internal();

  Future<void> open() async {
    _store = await openStore();
  }


  closeStore() {
     _store.close();
  }

  Future<MyObject> createMyObject(String? videoName, String? datetime, List<List<double>?> emotions) async {
    var obj = MyObject();
    obj.videoName = videoName;
    obj.datetime = datetime;
    obj.arrays = emotions;
    return obj;
  }

  Future<void> saveMyObjectData(MyObject obj) async {
    print("__________${obj.arrays}");
    _store.box<MyObject>().put(obj);
  }

  Future<List<MyObject>> getAllMyObjectData() async {
    final myObjects = _store.box<MyObject>().getAll();
    return myObjects;
  }
}
