
class ListManager {
  List<List<double>?> arr;
  List<List<double>?>? arrEmotions;

  ListManager(this.arr){
    arrEmotions = removeFirstElements(arr);
  }


  int countUniqueFirstElements(List<List<double>> data) {
    // Sử dụng một tập hợp để lưu trữ các giá trị đầu tiên duy nhất
    Set<double> uniqueFirstElements = {};

    for (var list in data) {
      if (list != null && list.isNotEmpty) {
        uniqueFirstElements.add(list[0]);
      }
    }

    return uniqueFirstElements.length;
  }


  List<List<double>?> removeFirstElements(List<List<double>?> data) {
    List<List<double>?> result = [];

    for (var list in data) {
      if(list == null){
        result.add(null);
        continue;
      }
      if (list != null && list.length > 1) {
        result.add(list.sublist(1));
      }
    }

    return result;
  }


  List<double> averageByPosition(List<List<double>?> data) {
    if (data.isEmpty || data.every((list) => list == null || list.isEmpty)) {
      return [];
    }


    List<double> sums = List.filled(7, 0.0);
    List<int> counts = List.filled(7, 0);

    for (var list in data) {
      if (list != null) {
        for (int i = 0; i < list.length; i++) {
          sums[i] += list[i];
          counts[i]++;
        }
      }
    }

    // Tính giá trị trung bình cho từng vị trí
    List<double> averages = [];
    for (int i = 0; i < 7; i++) {
      if (counts[i] > 0) {
        averages.add(sums[i] / counts[i]);
      } else {
        averages.add(0.0);
      }
    }

    return averages;
  }


  List<int> countMaxOccurrencesByPosition(List<List<double>?> data) {
    if (data.isEmpty || data.every((list) => list == null || list.isEmpty)) {
      return [];
    }

    // Tìm danh sách con dài nhất để xác định số lượng phần tử cần đếm
    int maxLength = 7;

    List<int> maxCounts = List.filled(maxLength, 0);

    for (var list in data) {
      if (list != null && list.isNotEmpty) {
        double maxValue = list[0];
        int maxIndex = 0;
        for (int i = 1; i < list.length; i++) {
          if (list[i] > maxValue) {
            maxValue = list[i];
            maxIndex = i;
          }
        }
        // Tăng số đếm cho vị trí có giá trị lớn nhất
        maxCounts[maxIndex]++;
      }
    }

    return maxCounts;
  }


}