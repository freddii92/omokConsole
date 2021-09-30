// Author: Alfredo Rodriguez
// Last modified: April 6, 2021

import 'web_client.dart';

/// Class to parse json information given from server.
class ResponseParser {

  /// Parses [json] information from server.
  /// [json] = json
  Info parseInfo(json) {
    return Info(json['size'], json['strategies']);
  }

  /// Parses [json] new from server.
  /// [json] = json
  New parseNew(json) {
    return New(json['response'], json['pid']);
  }

  /// Parses [json] moves from server.
  /// [json] = json
  Move parseMove(json) {
    return Move(json['ack_move'], json['move']);
  }
}