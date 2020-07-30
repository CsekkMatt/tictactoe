import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ticktacktoe/custom_dialog.dart';
import 'package:ticktacktoe/game_button.dart';
import 'package:ticktacktoe/minimax.dart';
import 'package:ticktacktoe/select_difficulty.dart';

enum Direction { left, right }

enum Player { human, bot }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonList;
  var player1;
  var player2;
  var activePlayer;
  int human = 1, ai = 2;

  @override
  void initState() {
    super.initState();
    buttonList = doInit();
  }

  List<GameButton> doInit() {
    player1 = new List();
    player2 = new List();
    activePlayer = human;
    var gameButtons = <GameButton>[
      new GameButton(id: 0),
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        activePlayer = ai;
        player1.add(gb.id);
      } else {
        gb.text = "O";
        gb.bg = Colors.blue;
        activePlayer = human;
        player2.add(gb.id);
      }
      gb.enabled = false;
      if (!isGameEnd() && activePlayer == ai) {
        int bestMove =
            MiniMax(board: buttonList, humanPlayer: player1, aiPlayer: player2)
                .getBestNextMove();
        print(DifficultyWidget().key.toString());
        playGame(buttonList[bestMove]);
        //autoPlay();
      }
    });
  }

  bool isGameEnd() {
    if (playerCheck(player1)) {
      showDialog(
          context: context,
          builder: (_) => new CustomDialog("Player 1 won",
              "Press the reset button to start a new game", resetGame));

      return true;
      //player 1 won
    } else if (playerCheck(player2)) {
      showDialog(
          context: context,
          builder: (_) => new CustomDialog("Player 2 won",
              "Press the reset button to start a new game", resetGame));
      return true;
    } else if (tieGame(buttonList)) {
      showDialog(
          context: context,
          builder: (_) => new CustomDialog("Tie game",
              "Press the reset button to start a new game", resetGame));
      return true;
    }
    return false;
  }

  bool tieGame(var buttonList) {
    if (buttonList.every((element) => element.text != "")) {
      return true;
    }
    return false;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonList = doInit();
    });
  }

  void autoPlay() {
    var emptyCells = new List();
    var list = new List.generate(9, (i) => i + 1);

    for (var cellId in list) {
      if (!player1.contains(cellId) && !player2.contains(cellId)) {
        emptyCells.add(cellId);
      }
    }
    var r = new Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    var cellId = emptyCells[randIndex];
    int i = buttonList.indexWhere((element) => element.id == cellId);
    int nextMoveIndex = bot();
    if (nextMoveIndex == null) {
      nextMoveIndex = i;
    }
    playGame(buttonList[nextMoveIndex]);
  }

  //retrun the next move index
  int bot() {
    List<GameButton> copyButtonList = List.from(buttonList);
    int winnerMove = getWinnerMove(player2, copyButtonList);
    int enemyWinnerMove = getWinnerMove(player1, copyButtonList);
    int nextMoveIndex = winnerMove;
    print("WinnerMove:");
    print(winnerMove);
    if (winnerMove == null && enemyWinnerMove != null) {
      print("enemyWinnerMove applied");
      print(enemyWinnerMove);
      return enemyWinnerMove;
    }
    if (winnerMove == null) {
      //check player1 chance to win
      //if have one change. select that box

      nextMoveIndex = checkNextMove(copyButtonList);
      print("Next Move Index: ");
      print(nextMoveIndex);
      buttonList.forEach((element) {
        print(element.text);
      });
    }

    return nextMoveIndex;
  }

  int checkNextMove(List<GameButton> copyButtonList) {
    var list = new List.generate(9, (i) => i);
    for (var index in list) {
      if (player1.contains(index) || copyButtonList[index].text == "X") {
        continue;
      }
      if (player2.contains(index) || copyButtonList[index].text == "O") {
        continue;
      }
      if (nextMoveLogic(index, copyButtonList)) {
        print("Next move, without a winner:");
        print(index);
        return index;
      }
    }
    return -2;
  }

  //return the winnerMove if exist
  int getWinnerMove(var currentPlayer, List<GameButton> copyButtonList) {
    var winnerMove;
    var botPlayer = List.from(currentPlayer);
    var list = new List.generate(9, (i) => i);
    for (var index in list) {
      if (player1.contains(index) || player2.contains(index)) {
        continue;
      }
      botPlayer.add(index);
      if (playerCheck(botPlayer)) {
        winnerMove = index;
        break;
      }
      if (tieGame(copyButtonList)) {
        print("TieGame");
        break;
      }
      botPlayer.removeLast();
    }
    return winnerMove;
  }

  //return if the next move index it's OK
  bool nextMoveLogic(int index, List<GameButton> copyButtons) {
    if (index > 2 && index < 6) {
      //up neighbour
      if (copyButtons[index - 3].text == "O") {
        print("-3 check");
        print(copyButtons[index - 3].id);
        return true;
      }
      //left neighbour
      if (buttonList[index - 1].text == "O") {
        print(buttonList[index - 1].id);
        return true;
      }
      //right neighbour
      if (buttonList[index + 1].text == "O") {
        print(buttonList[index + 1].id);
        return true;
      }
      if (copyButtons[index + 3].text == "O") {
        print("+3 check");
        print(copyButtons[index + 3].id);
        return true;
      }
      if (copyButtons[index + 2].text == "O") {
        print("+2 check");
        return true;
      }
      if (copyButtons[index - 2].text == "O") {
        print("-2 check");
        return true;
      }
    }
    return false;
  }

  //Check if the specified player has won the game
  bool playerCheck(var player) {
    if (player.contains(0) && player.contains(1) && player.contains(2)) {
      return true;
    }
    if (player.contains(3) && player.contains(4) && player.contains(5)) {
      return true;
    }
    if (player.contains(6) && player.contains(7) && player.contains(8)) {
      return true;
    }
    if (player.contains(0) && player.contains(3) && player.contains(6)) {
      return true;
    }
    if (player.contains(1) && player.contains(4) && player.contains(7)) {
      return true;
    }
    if (player.contains(2) && player.contains(5) && player.contains(8)) {
      return true;
    }
    if (player.contains(0) && player.contains(4) && player.contains(8)) {
      return true;
    }
    if (player.contains(6) && player.contains(4) && player.contains(2)) {
      return true;
    }
    return false;
  }

  ///final diff = new GlobalKey<_SettingsWidgetState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Tict Tac Toe"),
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: new GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 9.0),
                itemCount: buttonList.length,
                itemBuilder: (context, i) => new SizedBox(
                  width: 100,
                  height: 100,
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: buttonList[i].enabled
                        ? () => playGame(buttonList[i])
                        : null,
                    child: new Text(
                      buttonList[i].text,
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: buttonList[i].bg,
                    disabledColor: buttonList[i].bg,
                  ),
                ),
              ),
            ),
            new DifficultyWidget(),
            new RaisedButton(
              child: new Text(
                "Reset",
                style: new TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: Colors.red,
              padding: const EdgeInsets.all(20.0),
              onPressed: resetGame,
            )
          ],
        ));
  }
}
