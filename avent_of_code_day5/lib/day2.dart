import 'dart:io';

void runTask(String inputFile) async {
  var input = File(inputFile);

  // subract 1 because the first increase isn't real (since it's the first measurement, no "increase" is possible
  simpleDepthAndDistanceCalculation(input)
      .then((value) => print('Day 1, Part 1 answer: ${value}'));

  aimAssistedDepthAndDistanceCalculation(input)
      .then((value) => print('Day 1, Part 2 answer: ${value}'));
}

Future<int> simpleDepthAndDistanceCalculation(File input) async {
  //task vars
  int depth = 0;
  int distance = 0;

  //create inputData
  await input.readAsLines().then((List<String> list) {
    for (String line in list) {
      List command = line.split(" ");
      String instruction = command[0];
      int? amount = int.tryParse(command[1]);
      if (amount != null) {
        switch (instruction) {
          case "forward":
            distance += amount;
            break;
          case "up":
            depth -= amount;
            break;
          case "down":
            depth += amount;
            break;
        }
      }
    }
  });

  return depth * distance;
}

Future<int> aimAssistedDepthAndDistanceCalculation(File input) async {
  //task vars
  int depth = 0;
  int distance = 0;
  int aim = 0;
  //create inputData
  await input.readAsLines().then((List<String> list) {
    for (String line in list) {
      List command = line.split(" ");
      String instruction = command[0];
      int? amount = int.tryParse(command[1]);
      if (amount != null) {
        switch (instruction) {
          case "forward":
            distance += amount;
            depth += aim * amount;
            break;
          case "up":
            aim -= amount;
            break;
          case "down":
            aim += amount;
            break;
        }
      }
    }
  });

  return depth * distance;
}
