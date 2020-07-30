import 'dart:math';

import 'package:ticktacktoe/check_utils.dart';

import 'game_button.dart';

class MiniMax {
  int itreations = 0;
  List<GameButton> board;
  var humanPlayer, aiPlayer;
  String human = "X", ai = "O";
  var list = new List.generate(9, (i) => i);
  MiniMax({this.board, this.humanPlayer, this.aiPlayer});

  int getBestNextMove() {
    double bestScore = double.negativeInfinity;
    double score;
    int nextMove;
    for (int index in list) {
      //Is the spot available?
      if (board[index].text == "") {
        board[index].text = ai;
        aiPlayer.add(index);
        score = minimax(board, 0, false);
        aiPlayer.removeLast();
        board[index].text = "";
        if (score > bestScore) {
          bestScore = score;
          nextMove = index;
        }
      }
    }
    print(itreations);
    return nextMove;
  }

  double minimax(List<GameButton> board, int depth, bool isMaximizing) {
    if (WinnerCheckUtils().playerCheck(aiPlayer)) {
      return 10.0;
    }
    if (WinnerCheckUtils().playerCheck(humanPlayer)) {
      return -10.0;
    }
    if (WinnerCheckUtils().tieGame(board)) {
      return 0.0;
    }
    if (isMaximizing) {
      double bestScore = double.negativeInfinity;
      for (int index in list) {
        if (board[index].text == "") {
          board[index].text = ai;
          aiPlayer.add(index);
          double score = minimax(board, depth + 1, false);
          aiPlayer.removeLast();
          board[index].text = "";
          bestScore = max(score, bestScore);
        }
        //Is the spot available
      }
      itreations++;
      return bestScore;
    } else {
      double bestScore = double.infinity;
      for (int index in list) {
        if (board[index].text == "") {
          board[index].text = human;
          humanPlayer.add(index);
          double score = minimax(board, depth + 1, true);
          humanPlayer.removeLast();
          board[index].text = "";
          bestScore = min(score, bestScore);
        }
      }
      itreations++;
      return bestScore;
    }
  }
}
