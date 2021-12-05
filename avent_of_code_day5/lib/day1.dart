import 'dart:io';

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
