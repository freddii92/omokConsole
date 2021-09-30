// Author: Alfredo Rodriguez
// Last modified: April 6, 2021

import 'dart:io';
import 'model.dart';

/// User input class
class ConsoleUI {

  /// Prints messages.
  void printMessage(message) {
    stdout.writeln(message);
  }

  /// This function will show the current status of the board.
  /// [_board] = board
  /// [size] = size of board
  void showBoard(Board _board, int size) {

    var line = List<int>.generate(size, (i) => (i + 1) % 10).join(' ');
    stdout.writeln(' x $line');
    line = List<String>.generate(size, (i) => '--').join();
    stdout.writeln('y $line');

    var y = 0;
    for (var i = 0; i < _board.size; i++) {
      y++;
      var line = _board.rows[i].join(' ');
      stdout.writeln('${y % 10} | $line');
    }
    printMessage('Player: O, Server: X (and *)');
  }

  /// Asks the user to enter the server URL. [DEFAULT_URL] if not specified.
  /// [defaultUrl] = Default URL specified in web_client.dart
  String promptServer(String defaultUrl) {
    printMessage('Enter the server URL [default: $defaultUrl] ');
    var url = stdin.readLineSync();
    if (url.isEmpty) {
      url = defaultUrl;
    }
    return url;
  }

  /// Asks the user to select a strategy.
  /// [strategies] = Strategies from server.
  String promptStrategy(strategies) {

    var success = false;
    var selection;
    while (!success) {
      printMessage('Select the server strategy: 1. Smart 2. Random [default: 1] ');
      var line = stdin.readLineSync();
      try {
        selection = int.parse(line);
        if (selection == 1 || selection == 2) {
          success = true;
        }
        else {
          printMessage('Invalid selection: $selection');
        }
      } on FormatException {
        printMessage('Invalid selection: $line');
      }
    }
    return strategies[selection-1];
  }

  /// Asks the user to select a move.
  /// [_board] = board
  List<int> promptMove(Board _board) {

    var success = false;
    var x;
    var y;
    while (!success) {
      printMessage('Enter x and y (1-${_board.size}, e.g., 8 10): ');
      var line = stdin.readLineSync().trim();
      var split = line.split(RegExp(r' *[ |, ] *'));
      if (split.length != 2) {
        printMessage('Invalid Index!');
        continue;
      }
      try {
        x = int.parse(split[0])-1;
        y = int.parse(split[1])-1;
        if (_board.isEmptyPlace(x, y)) {
          _board.setPlayerMove(x, y);
          break;
        }
        else {
          printMessage('Not empty!');
          continue;
        }
      } on FormatException {
        printMessage('Invalid index!');
      } on RangeError {
        printMessage('Invalid index!');
      }
    }
    return [x, y];
  }
}