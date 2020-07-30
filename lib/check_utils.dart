class WinnerCheckUtils {
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

  bool tieGame(var buttonList) {
    if (buttonList.every((element) => element.text != "")) {
      return true;
    }
    return false;
  }
}
