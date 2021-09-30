// Author: Alfredo Rodriguez
// Last modified: April 6, 2021

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'response_parser.dart';

/// Webclient class that gets information from server.
class WebClient {
  /// Default URL
  static const DEFAULT_URL = 'http://omok.atwebpages.com/';
  /// Set info part of URL
  static const _INFO = '/info/';
  /// Set new part of URL
  static const _NEW = '/new/';
  /// Set play part of URL
  static const _PLAY = '/play/';
  /// Set strategy part of URL
  static const _STRATEGY_QUERY = 'strategy';
  /// Set pid part of URL
  static const _PID_QUERY = 'pid';
  /// Set move part of URL
  static const _MOVE_QUERY = 'move';

  final _server;
  final _parser = ResponseParser();

  /// [WebClient] constructor
  WebClient(this._server);

  /// Gets info from [_server]
  Future<Info> getInfo() async {
    var response = await http.get(Uri.parse(_server + _INFO));
    return _parser.parseInfo(json.decode(response.body));
  }

  /// Gets pid from [_server]
  /// [strategy] = Strategy select from user.
  Future<New> getPid(strategy) async {
    var newGameUrl = _NEW + '?' + _STRATEGY_QUERY + '=' + strategy;
    var pid = await http.get(Uri.parse(_server + newGameUrl));
    return _parser.parseNew(json.decode(pid.body));
  }

  /// Gets move from [_server]
  /// [pid] = Stored pid created by server
  /// [x] = User's x coordinate move
  /// [y] = User's y coordinate move
  Future<Move> getMove(pid, x, y) async {
    var playUrl = _PLAY + '?' + _PID_QUERY + '=' + pid + '&' + _MOVE_QUERY + '=' +
    '$x' + ',' + '$y';
    var move = await http.get(Uri.parse(_server + playUrl));
    return _parser.parseMove(json.decode(move.body));
  }
}

/// Info class with [size] and [strategies] variables given from the server.
class Info {
  final size;
  final strategies;
  Info(this.size, this.strategies);
}

/// New class with [response] and [pid] variables given from the server.
class New {
  final response;
  final pid;
  New(this.response, this.pid);
}

/// Move class with [ack_move] and [move] variables given from the server.
class Move {
  final ack_move;
  final move;
  Move(this.ack_move, this.move);
}