import 'package:facial_emotions/manager/barchart_page.dart';
import 'package:facial_emotions/models/myobject.dart';
import 'package:facial_emotions/utils/process_list.dart';
import 'package:flutter/material.dart';

import '../home/utils.dart';

class StatisticsDetailPage extends StatefulWidget {
  final MyObject object;
  StatisticsDetailPage({super.key, required this.object});

  @override
  State<StatisticsDetailPage> createState() => _StatisticsDetailPageState();
}

class _StatisticsDetailPageState extends State<StatisticsDetailPage> {
  late MyObject object;
  List<List<double>?> arrEmotions = [];
  List<double> averageEmotions = [];
  List<int> emotionCounts = [];
  final List<String> emotionNames = listEmotionNames;

  @override
  void initState() {
    super.initState();
    object = widget.object;
    initData();
  }

  void initData() {
    if (object.arrays == null) {
      return;
    }
    ListManager listManager = ListManager(object.arrays!);
    arrEmotions = listManager.arrEmotions!;
    averageEmotions = listManager.averageByPosition(arrEmotions).map((value) => value * 100).toList();
    emotionCounts = listManager.countMaxOccurrencesByPosition(arrEmotions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(object.videoName!),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Video Duration: 10s',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Number of measured data: ${object.arrays?.length.toString()}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Average emotional index:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                  },
                  border: TableBorder.all(color: Colors.grey),
                  children: [
                    for (int i = 0; i < averageEmotions.length; i++)
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              emotionNames[i],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${averageEmotions[i].toStringAsFixed(2)}%",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              BarChartPage(
                columnData: averageEmotions,
                emotionNames: emotionNames,
              ),
              const SizedBox(height: 16),
              const Text(
                'Number of times the emotion appears:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              border: TableBorder.all(color: Colors.grey),
              children: [
                for (int i = 0; i < emotionCounts.length; i++)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          emotionNames[i],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${emotionCounts[i]} times',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
            ),
          ),
              const SizedBox(height: 16),
              BarChartPage(
                columnData: emotionCounts,
                emotionNames: emotionNames,
              ),
              const SizedBox(height: 26),

            ],
          ),
        ),
      ),
    );
  }
}
