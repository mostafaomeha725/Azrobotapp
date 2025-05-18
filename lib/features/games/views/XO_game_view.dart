import 'dart:math';

import 'package:azrobot/features/games/views/XO_game_view.dart' as GameLogic;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class BoardController extends ChangeNotifier {
  final List<CellValue> _board = List<CellValue>.filled(9, CellValue.empty);

  List<CellValue> getBoard() => List.unmodifiable(_board);

  CellValue getCellValue(int index) => _board[index];

  void setCellValue(int index, CellValue value) {
    if (_board[index] == value) return;
    _board[index] = value;
    notifyListeners();
  }

  void resetBoard() {
    for (int i = 0; i < _board.length; i++) {
      _board[i] = CellValue.empty;
    }
    notifyListeners();
  }
}

// import '../utils/game_logic.dart' as GameLogic;

class GameController extends ChangeNotifier {
  GameController({
    required this.boardController,
    this.aiAutoPlay = CellValue.empty,
  }) {
    randomStart();
  }

  CellValue aiAutoPlay;
  bool _isPlaying = true;
  BoardController boardController;
  bool _isPlayerXTurn = true;
  CellValue _winner = CellValue.empty;

  bool get isPlayerXTurn => _isPlayerXTurn;
  bool get hasWinner => _winner != CellValue.empty;
  bool get isDraw => _winner == CellValue.draw;
  CellValue get winner => _winner;
  bool get isPlaying => _isPlaying;

  CellValue get currentPlayer => _isPlayerXTurn ? CellValue.x : CellValue.o;
  String get currentPlayerString => mapCellValueToString(currentPlayer);
  Color get currentPlayerColor => mapCellValueToColor(currentPlayer);

  void randomStart() {
    _isPlayerXTurn = Random().nextBool();
    notifyListeners();
    if (aiAutoPlay == currentPlayer) aiPlay();
  }

  void changeTurn() {
    _isPlayerXTurn = !_isPlayerXTurn;
    notifyListeners();
  }

  /// restart the game and choose player to start
  ///
  /// use random player if [randomPlayer] is true (**default**)
  ///
  /// use [player] __y__ if [randomPlayer] is false,
  /// __y__ is the [CellValue] to start with
  ///
  /// use last winner if [hasWinner]
  ///
  /// finally set player to `CellValue.x` if all above is false
  ///
  void restartGame({bool randomPlayer = true, CellValue? player}) {
    if (randomPlayer) {
      randomStart();
    } else if (player != null) {
      _isPlayerXTurn = player == CellValue.x;
    } else if (hasWinner) {
      _isPlayerXTurn = _winner == CellValue.x;
    } else {
      _isPlayerXTurn = true;
    }

    _winner = CellValue.empty;
    _isPlaying = true;
    boardController.resetBoard();
    notifyListeners();
  }

  void onCellTap(int index) {
    if (!_isPlaying) return;
    if (currentPlayer == aiAutoPlay) return; // منع التفاعل مع الـ AI

    final oldValue = boardController.getCellValue(index);
    if (oldValue != CellValue.empty) return;

    late CellValue newValue;
    if (isPlayerXTurn) {
      newValue = CellValue.x; // اللاعب X
    } else {
      newValue = CellValue.o; // اللاعب O
    }

    changeTurn();
    boardController.setCellValue(index, newValue);

    checkWinner();

    // بعد حركة اللاعب، يتم تشغيل AI مباشرة إذا كان AI هو اللاعب التالي
    if (aiAutoPlay == currentPlayer) aiPlay();
  }

  void checkWinner() {
    final winner = GameLogic.checkWinner(boardController.getBoard());
    if (winner == CellValue.draw) {
      _winner = CellValue.draw;
      _isPlaying = false;
    } else if (winner != CellValue.empty) {
      _winner = winner;
      _isPlaying = false;
      notifyListeners();
    }
  }

  void aiPlay() {
    if (hasWinner) return; // إذا كان هناك فائز، توقف اللعبة

    // تحديد الحركة الأفضل للـ AI
    final aiMove = GameLogic.getAiMove(
      boardController.getBoard(),
      currentPlayer,
      currentPlayer == CellValue.x ? CellValue.o : CellValue.x,
    );

    boardController.setCellValue(aiMove, currentPlayer); // تعيين القيمة للحركة
    changeTurn(); // تغيير الدور
    checkWinner(); // التحقق من الفائز
  }
}

class XoGameView extends StatefulWidget {
  const XoGameView({super.key});

  @override
  State<XoGameView> createState() => _XoGameViewState();
}

class _XoGameViewState extends State<XoGameView> {
  late final BoardController boardController;
  late final GameController gameController;

  @override
  void initState() {
    super.initState();
    boardController = BoardController();
    gameController = GameController(
      boardController: boardController,
      aiAutoPlay: CellValue.o, // جعل AI هو اللاعب O
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    boardController.dispose();
    gameController.dispose();
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Container(
          height: 40, // الحجم الذي تريده
          width: 40, // الحجم الذي تريده
          decoration: BoxDecoration(
            color: Color(0xFF0062CC), // اللون الأزرق
            borderRadius: BorderRadius.circular(10), // تحديد الحواف الدائرية
          ),
          child: IconButton(
            icon: Icon(
              Icons.chevron_left_sharp, // أيقونة العودة
              color: Colors.white, // لون الأيقونة الأبيض
              size: 24, // حجم الأيقونة
            ),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Click a cell when it\'s your move.',
                style: TextStyle(fontSize: 18.0),
              ),
              AnimatedBuilder(
                animation: gameController,
                builder: (context, _) {
                  if (gameController.isDraw) {
                    return const Text(
                      'Draw!',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: Colors.orange,
                      ),
                    );
                  } else if (gameController.hasWinner) {
                    return Text(
                      'Winner is ${mapCellValueToString(gameController.winner)}',
                      style: const TextStyle(
                        fontSize: 32.0,
                        color: Colors.green,
                      ),
                    );
                  } else {
                    return Text(
                      'Player ${gameController.currentPlayerString}\'s turn.',
                      style: TextStyle(
                        fontSize: 32.0,
                        color: gameController.currentPlayerColor,
                      ),
                    );
                  }
                },
              ),
              XOBoard(
                controller: boardController,
                onCellTap: gameController.onCellTap,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  child: const Text(
                    'RESTART GAME',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    gameController.restartGame(randomPlayer: false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum CellValue {
  empty,
  x,
  o,
  draw,
}

String mapCellValueToString(CellValue value) {
  switch (value) {
    case CellValue.empty:
      return 'Empty';
    case CellValue.draw:
      return 'Draw';
    case CellValue.x:
      return 'X';
    case CellValue.o:
      return 'O';
  }
}

Color mapCellValueToColor(CellValue value) {
  switch (value) {
    case CellValue.empty:
      return Colors.white;
    case CellValue.draw:
      return Colors.white;
    case CellValue.x:
      return Colors.red;
    case CellValue.o:
      return Colors.blue;
  }
}

CellValue mapStringToCellValue(String value) {
  switch (value) {
    case 'Empty':
      return CellValue.empty;
    case 'Draw':
      return CellValue.draw;
    case 'X':
      return CellValue.x;
    case 'O':
      return CellValue.o;
    default:
      throw Exception('Invalid cell value: $value');
  }
}

const List<List<int>> kXORules = [
  // horizontal
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  // vertical
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  // diagonals
  [0, 4, 8],
  [2, 4, 6],
];

CellValue checkWinner(List<CellValue> board) {
  for (List<int> rule in kXORules) {
    final List<CellValue> pickedItems = pickItems(board, rule);
    final bool isRepeated = isItemsRepeated(pickedItems);
    if (isRepeated) return board[rule[0]];
  }

  if (board.every((c) => c != CellValue.empty)) return CellValue.draw;

  return CellValue.empty;
}

List<T> pickItems<T>(List<T> items, List<int> indices) {
  final List<T> pickedItems = [];
  for (int i = 0; i < indices.length; i++) {
    pickedItems.add(items[indices[i]]);
  }
  return pickedItems;
}

bool isItemsRepeated<T>(Iterable<T> list) {
  for (int i = 0; i < list.length - 1; i++) {
    if (list.elementAt(i) != list.elementAt(i + 1)) {
      return false;
    }
  }
  return true;
}

int getAiMove(
  List<CellValue> board,
  CellValue winPlayer,
  CellValue lossPlayer,
) {
  int bestScore = 0;
  int bestMove = -1;

  for (int i = 0; i < board.length; i++) {
    if (board[i] != CellValue.empty) continue;

    final List<CellValue> newBoard = List.from(board);
    newBoard[i] = winPlayer;

    final score = minMaxAi(newBoard, winPlayer, lossPlayer, false);

    if (bestMove == -1 || score > bestScore) {
      bestScore = score;
      bestMove = i;
    }
  }

  return bestMove;
}

int minMaxAi(
  List<CellValue> board,
  CellValue winPlayer,
  CellValue lossPlayer,
  bool isMin,
) {
  for (int i = 0; i < board.length; i++) {
    if (board[i] != CellValue.empty) continue;

    final List<CellValue> newBoard = List.from(board);
    newBoard[i] = isMin ? lossPlayer : winPlayer;

    final CellValue winner = checkWinner(newBoard);

    if (winner == winPlayer) {
      return 10;
    } else if (winner == lossPlayer) {
      return -10;
    } else if (winner == CellValue.draw) {
      return 0;
    } else {
      return minMaxAi(newBoard, winPlayer, lossPlayer, !isMin);
    }
  }

  return 0;
}

class XOBoard extends StatelessWidget {
  const XOBoard({
    super.key,
    required this.controller,
    required this.onCellTap,
  });

  final BoardController controller;
  final void Function(int index) onCellTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(builder: (context, box) {
        return SizedBox(
          width: box.maxWidth,
          height: box.maxWidth,
          child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final board = controller.getBoard();

                return GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  shrinkWrap: true,
                  children: [
                    for (int i = 0; i < board.length; i++)
                      GestureDetector(
                        onTap: () => onCellTap(i),
                        child: Cell(
                          width: box.maxWidth / 3,
                          value: board[i],
                        ),
                      ),
                  ],
                );
              }),
        );
      }),
    );
  }
}

class Cell extends StatelessWidget {
  const Cell({
    super.key,
    required this.width,
    required this.value,
  });

  final double width;
  final CellValue value;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: mapCellValueToColor(value),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: Text(
          mapCellValueToString(value),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}
