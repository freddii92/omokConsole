// Author: Alfredo Rodriguez
// Last modified: April 6, 2021

/// Class to update board with [_WINNER], [size], and [rows] as variables.
class Board {
  static final _WINNER = Player('W');
  var size;
  var rows;

  /// [Board] constructor.
  Board();

  /// Sets user's move to board denoted with O.
  /// [x] = User's x coordinate.
  /// [y] = User's y coordinate.
  void setPlayerMove(var x, var y) {
    final _player = Player('O');
    rows[y][x] = _player.stone;
  }

  /// Sets server's current move to board denoted with *.
  /// This function will also change previous moves to X.
  /// [x] = Server's x coordinate.
  /// [y] = Server's y coordinate.
  void setServerMove(var x, var y) {
    final _player = Player('*');
    for (var row = 0; row < rows.length; row++) {
      for (var col = 0; col < rows[row].length; col++) {
        if (rows[row][col] == '*') {
          rows[row][col] = 'X';
        }
      }
    }
    rows[y][x] = _player.stone;
  }

  /// Set's winning indices on Board denoted with W.
  /// [winningIndices] = Winning indices given by server.
  void setWinningIndices(winningIndices) {
    for (var index = 0; index < winningIndices.length; index += 2) {
      rows[winningIndices[index + 1]][winningIndices[index]] = _WINNER.stone;
    }
  }

  /// Checks if place picked is empty.
  /// Returns true or false.
  /// [x] = X coordinate.
  /// [y] = Y coordinate.
  bool isEmptyPlace(var x, var y) {
    return rows[y][x] == '.';
  }

}

/// Player class with [stone] variable depending on player.
class Player {
  var stone;
  Player(this.stone);
}