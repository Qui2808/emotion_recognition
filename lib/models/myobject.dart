import 'dart:convert';
import 'package:objectbox/objectbox.dart';

@Entity()
class MyObject {
  @Id(assignable: true)
  int id = 0;

  String? videoName;
  String? datetime;

  // Thuộc tính lưu trữ dưới dạng JSON
  String? arraysJson;

  // Getter và Setter để chuyển đổi giữa List<List<double>?>? và String
  @Transient()
  List<List<double>?>? get arrays {
    if (arraysJson == null) return null;
    List<dynamic> jsonData = json.decode(arraysJson!);
    return jsonData.map((item) => item == null ? null : List<double>.from(item)).toList();
  }

  set arrays(List<List<double>?>? value) {
    if (value == null) {
      arraysJson = null;
    } else {
      arraysJson = json.encode(value);
    }
  }

  MyObject();

}

