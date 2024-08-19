import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _BarChart extends StatelessWidget {
  final List<num> columnData;
  final List<String> emotionNames;

  const _BarChart({
    required this.columnData,
    required this.emotionNames,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: columnData.isNotEmpty
            ? (columnData.map((e) => e.toDouble()).reduce((a, b) => a > b ? a : b) * 1.2)
            : 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.cyan,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue.shade800,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(emotionNames[value.toInt()], style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      Colors.blue.shade800,
      Colors.cyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> get barGroups => List.generate(
    columnData.length,
        (index) => BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: columnData[index].toDouble(),
          gradient: _barsGradient,
        ),
      ],
      showingTooltipIndicators: [0],
    ),
  );
}

class BarChartPage extends StatefulWidget {
  final List<num> columnData;
  final List<String> emotionNames;

  const BarChartPage({
    super.key,
    required this.columnData,
    required this.emotionNames,
  });

  @override
  State<StatefulWidget> createState() => BarChartPageState();
}

class BarChartPageState extends State<BarChartPage> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: _BarChart(
        columnData: widget.columnData,
        emotionNames: widget.emotionNames,
      ),
    );
  }
}
