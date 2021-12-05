import 'dart:io';

//data structure to hold line pairs
class LinePairs {
  int x1 = 0;
  int x2 = 0;
  int y1 = 0;
  int y2 = 0;

  LinePairs(this.x1, this.x2, this.y1, this.y2);

  //returns the corresponding List of points
  //that are covered by the class line
  List<List<int>> createActiveMapOfLine() {
    var pointMap = <List<int>>[];

    if (x1 == x2) {
      //create a new list of the points between the
      var newList = List.generate((y2 - y1).abs() + 1, (index) {
        late int entry;
        if (y1 < y2) {
          entry = y1 + index;
        } else {
          entry = y2 + index;
        }

        return entry;
      });
      for (var item in newList) {
        pointMap.add([x1, item]);
      }
    } else if (y1 == y2) {
      //create a new list of the points between the
      var newList = List.generate((x2 - x1).abs() + 1, (index) {
        late int entry;
        if (x1 < x2) {
          entry = x1 + index;
        } else {
          entry = x2 + index;
        }

        return entry;
      });
      for (var item in newList) {
        pointMap.add([item, y1]);
      }
    } else {
      //assume diagonal lines here
      //create a new list of the points between the
      var xList = List.generate((x2 - x1).abs() + 1, (index) {
        late int entry;
        if (x1 < x2) {
          entry = x1 + index;
        } else {
          entry = x1 - index;
        }

        return entry;
      });

      var yList = List.generate((y2 - y1).abs() + 1, (index) {
        late int entry;
        if (y1 < y2) {
          entry = y1 + index;
        } else {
          entry = y1 - index;
        }

        return entry;
      });
      if (yList.length == xList.length) {
        for (var index = 0; index < yList.length; index++) {
          pointMap.add([xList[index], yList[index]]);
        }
      }
    }

    return pointMap;
  }
}

const int movingAverageWindow = 3;

void runTask(String inputFile) async {
  var input = File(inputFile);
  var inputData = <int>[];

  //create inputData
  await input.readAsLines().then((List<String> list) {
    for (String line in list) {
      //get only valid coordinate pairs from input
      var currentMeasuerement = int.tryParse(line);
      if (currentMeasuerement != null) {
        inputData.add(currentMeasuerement);
      }
    }
  });

  // subract 1 because the first increase isn't real (since it's the first measurement, no "increase" is possible
  print('Day 1, Part 1 answer: ${findIncreasesInListElements(inputData)}');
  print(
      'Day 1, Part 2 answer: ${findIncreasesInListElements(createMovingWindowList(inputData))}');
}

int findIncreasesInListElements(List<int> inputData) {
  var lastMeasurement = 0;
  var totalIncreases = 0;
  for (int currentMeasurement in inputData) {
    //get only valid coordinate pairs from input
    if (currentMeasurement > lastMeasurement) {
      totalIncreases++;
    }
    // save last measurement for comparison
    lastMeasurement = currentMeasurement;
  }

  return (totalIncreases - 1);
}

List<int> createMovingWindowList(List<int> inputData,
    {int movingWindow = movingAverageWindow}) {
  List<int> listOfMovingWindowValues = <int>[];

  List<int> movingBuffer = <int>[];

  for (var currentValue in inputData) {
    //buffer hasn't been filled up at all yet, so just
    //add the values to the list
    if (movingBuffer.length < movingWindow) {
      movingBuffer.add(currentValue);

      //special case
      if (movingBuffer.length == movingWindow) {
        //filled up, add the current window sum to the return list
        listOfMovingWindowValues.add(sumOfBuffer(movingBuffer));
      }
    } else {
      //remove the first element
      movingBuffer.removeAt(0);

      movingBuffer.add(currentValue);

      //filled up, add the current window sum to the return list
      listOfMovingWindowValues.add(sumOfBuffer(movingBuffer));
    }
  }

  return listOfMovingWindowValues;
}

int sumOfBuffer(List<int> buffer) {
  int sum = 0;
  for (var item in buffer) {
    sum += item;
  }

  return sum;
}
