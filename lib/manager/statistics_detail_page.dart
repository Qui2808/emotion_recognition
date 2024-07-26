import 'package:facial_emotions/models/myobject.dart';
import 'package:facial_emotions/utils/process_list.dart';
import 'package:flutter/material.dart';

class StatisticsDetailPage extends StatefulWidget {
  final MyObject object;  // Thêm ObjectBoxManager
  StatisticsDetailPage({super.key, required this.object});

  @override
  State<StatisticsDetailPage> createState() => _StatisticsDetailPageState();
}

class _StatisticsDetailPageState extends State<StatisticsDetailPage> {
  late MyObject object;
  List<List<double>?> arrEmotions =[];
  List<double> averageEmotions =[];
  List<int> emotionCounts =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    object = widget.object;
    initData();
  }

  void initData(){
    if(object.arrays == null) {
      return;
    }
    ListManager listManager = ListManager(object.arrays!);
    arrEmotions = listManager.arrEmotions!;
    averageEmotions =listManager.averageByPosition(arrEmotions);
    emotionCounts = listManager.countMaxOccurrencesByPosition(arrEmotions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(object.videoName!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thời gian video: 10s',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Số dữ liệu: ${object.arrays?.length.toString()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Biểu cảm trung bình:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            for (int i = 0; i < averageEmotions.length; i++)
              Text(
                'Biểu cảm ${i + 1}: ${averageEmotions[i].toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 16),
            Text(
              'Số lần xuất hiện biểu cảm:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            for (int i = 0; i < emotionCounts.length; i++)
              Text(
                'Biểu cảm ${i + 1}: ${emotionCounts[i]} lần',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
