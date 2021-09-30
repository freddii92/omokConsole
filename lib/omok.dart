// Author: Alfredo Rodriguez
// Last modified: April 6, 2021

import 'ui.dart';
import 'web_client.dart';
import 'model.dart';

/// Controller class which is the backbone of the app.
/// Connects to the server.
class Controller {

  /// Function to start game.
  void start() async {

    var ui = ConsoleUI();
    ui.printMessage('Welcome to Omok game!');

    var url = ui.promptServer(WebClient.DEFAULT_URL);

    var web;
    var info;
    while (true) {
      try {
        ui.printMessage('Obtaining server information...');
        web = WebClient(url);
        info = await web.getInfo();
        break;
      } catch (e) {
        ui.printMessage('Invalid server. Please try again.');
        url = ui.promptServer(WebClient.DEFAULT_URL);
      }
    }

    var strategy = ui.promptStrategy(info.strategies);
    ui.printMessage('Selected strategy: $strategy');

    ui.printMessage('Creating a new game...');

    var newGame = await web.getPid(strategy);
    var pid = newGame.pid;

    var _board = Board();
    _board.size = info.size;
    _board.rows = List.generate(_board.size, (i) => List.generate(_board.size, (j) => '.'));

    var playerMove;
    while (true) {
      ui.showBoard(_board, _board.size);
      playerMove = ui.promptMove(_board);
      var serverMove = await web.getMove(pid, playerMove[0], playerMove[1]);
      if (serverMove.ack_move['isWin'] != null && serverMove.ack_move['isWin']) {
        _board.setWinningIndices(serverMove.ack_move['row']);
        ui.showBoard(_board, _board.size);
        ui.printMessage('You won!');
        break;
      }
      if (serverMove.move['isWin'] != null && serverMove.move['isWin']) {
        _board.setWinningIndices(serverMove.move['row']);
        ui.showBoard(_board, _board.size);
        ui.printMessage('You lost!');
        break;
      }
      var isDraw = serverMove.ack_move['isDraw'];
      if (isDraw) {
        ui.showBoard(_board, _board.size);
        ui.printMessage('Draw!');
      }
      _board.setServerMove(serverMove.move['x'], serverMove.move['y']);
    }
  }
}