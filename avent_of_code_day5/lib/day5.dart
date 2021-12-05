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

void runTask(String inputFile) async {
  var input = File(inputFile);
  var coordinateList = <LinePairs>[];
  var pointList = <List<int>>[];

  await input.readAsLines().then((List<String> list) {
    for (String line in list) {
      //get only valid coordinate pairs from input
      var coordinatePairs = createLinePairs(line, returnDiagonals: true);

      if (coordinatePairs != null) {
        coordinateList.add(coordinatePairs);
      }
    }
  });

  for (var item in coordinateList) {
    pointList.addAll(item.createActiveMapOfLine());
  }

//  print('$pointList');

  int totalPointsDuplicated = 0;
  var copyPointList = List.from(pointList);

  for (var item in pointList) {
    var removeCount = 0;

    //keeps track of items found that match
    var duplicateItemList = <List<int>>[];

    for (var copyItem in copyPointList) {
      if (copyItem[0] == item[0] && copyItem[1] == item[1]) {
        duplicateItemList.add(copyItem);
      }
    }

    //remove all elements that match the item
    for (var item in duplicateItemList) {
      copyPointList.remove(item);
      removeCount++;
    }

    //removed more than one of the matching element,
    //which means that it was duplicated at least once
    if (removeCount > 1) {
      totalPointsDuplicated++;
      print('Found $totalPointsDuplicated so far');
      print('Points Remaining ${copyPointList.length}');
    }
  }
  print('$totalPointsDuplicated');
}

LinePairs? createLinePairs(String line, {bool returnDiagonals = false}) {
  var mapPairs = <String, List<int>>{};
  //create lists for x
  mapPairs['x'] = List.empty(growable: true);
  mapPairs['y'] = List.empty(growable: true);

  var orderedPairs = line.split(" -> ");
  for (var pair in orderedPairs) {
    var coordinates = pair.split(',');
    mapPairs['x']!.add(int.parse(coordinates[0]));
    mapPairs['y']!.add(int.parse(coordinates[1]));
  }
  //create line pair object to hold the coordinates for each row
  LinePairs pair = LinePairs(mapPairs['x']?[0] ?? 0, mapPairs['x']?[1] ?? 0,
      mapPairs['y']?[0] ?? 0, mapPairs['y']?[1] ?? 0);

  if (returnDiagonals == false) {
    //check that at least one pair (x or y) have matching coordinate
    if (((mapPairs['x']?[0] == mapPairs['x']?[1]) ||
        (mapPairs['y']?[0] == mapPairs['y']?[1]))) {
      return pair;
    } else {
      return null;
    }
  } else {
    return pair;
  }
}
