import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ticktacktoe/custom_dialog.dart';
import 'package:ticktacktoe/game_button.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonList;
  var player1;
  var player2;
  var activePlayer;
  int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonList = doInit();
  }

  List<GameButton> doInit() {
    player1 = new List();
    player2 = new List();
    activePlayer = 1;
    var gameButtons = <GameButton>[
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
      new GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red;
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = "O";
        gb.bg = Colors.blue;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      if (!isGameEnd() && activePlayer == 2) {
        i++;
        print(i);
        autoPlay();
        if (i >= 2) {
          bot(gb);
        }
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
    playGame(buttonList[i]);
  }

//iterate trough every cell
//check the winner if exist
//if exist -> save this step as a potential winner move
//if no winner yet -> check neighbour cells for value
//if value == X -> rate with 0.25
//if vlaue == O -> rate with 0.5
//if winner -> rate with 1.0

  void bot(var board) {
    var botPlayer = List.from(player2);
    var copyButtonList = List.from(buttonList);
    var winnerMove, tieMove;
    var list = new List.generate(9, (i) => i + 1);
    var rate = 0;
    int savedElement;
    for (var index in list) {
      print(index);
      // copyButtonList[cell].text = "O";
      // copyButtonList[cell].bg = Colors.red;
      botPlayer.add(index);
      print(botPlayer);
      if (playerCheck(botPlayer)) {
        print("winnerMove");
        winnerMove = index;
        rate = 10;
        break;
      }
      if (tieGame(copyButtonList)) {
        print("TieGame");
        tieMove = index;
        rate = 1;
        break;
      }
      int nextMove = nextMoveLogic(index, buttonList);
      botPlayer.removeLast();
      // copyButtonList.removeLast();
    }
    print("WinnerMove:");
    print(winnerMove);
  }

  int nextMoveLogic(int index, var buttonList) {
    //check index neighbour's
    //choose the first next to neighbour
    //prioritize neighbours without a wall
    //up-down neighbours n-3
    //if n>3 can check back
    //if n>6 not check forward
    var rate = 0.0;
    if (index > 3 && index < 7) {
      //up neighbour
      if (buttonList[index - 3].text == "O") {
        rate += 5;
      }
      //left neighbour
      if (buttonList[index - 1].text == "O") {
        rate += 2;
      }
      //right neighbour
      if (buttonList[index + 1].text == "O") {
        rate += 2;
      }
      if (buttonList[index + 3].text == "O") {
        rate += 2;
      }
    }

    return 1;
  }

  bool itsWall(var index,var buttonList) {
    if(index == 1 || index == 3 || index == ){
      return true
    }
    return false;
  }

  bool playerCheck(var player) {
    if (player.contains(1) && player.contains(2) && player.contains(3)) {
      return true;
    }
    if (player.contains(1) && player.contains(4) && player.contains(7)) {
      return true;
    }
    if (player.contains(1) && player.contains(5) && player.contains(9)) {
      return true;
    }
    if (player.contains(3) && player.contains(5) && player.contains(7)) {
      return true;
    }
    if (player.contains(4) && player.contains(5) && player.contains(6)) {
      return true;
    }
    return false;
  }

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
