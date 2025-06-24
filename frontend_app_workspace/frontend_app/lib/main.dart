import 'package:flutter/material.dart';

// Color palette
const Color kPrimaryColor = Color(0xFF1976D2);
const Color kSecondaryColor = Color(0xFF424242);
const Color kAccentColor = Color(0xFFFFC107);

void main() {
  runApp(const TicTacToeApp());
}

// PUBLIC_INTERFACE
class TicTacToeApp extends StatelessWidget {
  /// The root widget for the modern, minimalistic Tic Tac Toe game.
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          background: Colors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 32,
            letterSpacing: 1.5,
          ),
          bodyMedium: TextStyle(
            color: kSecondaryColor,
            fontSize: 18,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: kPrimaryColor,
            side: const BorderSide(color: kPrimaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: kPrimaryColor,
            backgroundColor: Colors.transparent,
            splashFactory: InkRipple.splashFactory,
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: kPrimaryColor,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: const TicTacToeScreen(),
    );
  }
}

// PUBLIC_INTERFACE
class TicTacToeScreen extends StatefulWidget {
  /// The main screen for the game.
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

enum Player { X, O, none }

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<Player> board;
  late Player currentPlayer;
  late int xScore;
  late int oScore;
  late int drawScore;
  bool gameOver = false;
  String outcomeMessage = '';

  @override
  void initState() {
    super.initState();
    _initGame();
    xScore = 0;
    oScore = 0;
    drawScore = 0;
  }

  // PUBLIC_INTERFACE
  void _initGame() {
    /// Initializes or resets the board and state for a new game (not scores).
    board = List.generate(9, (_) => Player.none);
    currentPlayer = Player.X;
    gameOver = false;
    outcomeMessage = '';
    setState(() {});
  }

  // PUBLIC_INTERFACE
  void _handleTap(int idx) {
    /// Handles a cell tap, updating board and managing turn, win or draw state
    if (board[idx] != Player.none || gameOver) return;

    setState(() {
      board[idx] = currentPlayer;
      final win = _checkWinner();
      final draw = _isDraw();

      if (win != Player.none) {
        gameOver = true;
        outcomeMessage = "Player ${_playerText(win)} wins!";
        _updateScore(win);
      } else if (draw) {
        gameOver = true;
        outcomeMessage = "It's a draw!";
        drawScore += 1;
      } else {
        currentPlayer = currentPlayer == Player.X ? Player.O : Player.X;
      }
    });
  }

  // PUBLIC_INTERFACE
  Player _checkWinner() {
    /// Returns the winner [Player.X/O] if present, else [Player.none]
    const wins = [
      // rows
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      // cols
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      // diag
      [0, 4, 8], [2, 4, 6]
    ];
    for (var combo in wins) {
      final a = combo[0], b = combo[1], c = combo[2];
      if (board[a] != Player.none &&
          board[a] == board[b] &&
          board[b] == board[c]) {
        return board[a];
      }
    }
    return Player.none;
  }

  // PUBLIC_INTERFACE
  bool _isDraw() {
    /// True if the board is full and there is no winner.
    return board.every((cell) => cell != Player.none) && _checkWinner() == Player.none;
  }

  // PUBLIC_INTERFACE
  void _updateScore(Player winner) {
    /// Increments the score tally for the given [winner].
    if (winner == Player.X) {
      xScore += 1;
    } else if (winner == Player.O) {
      oScore += 1;
    }
  }

  // PUBLIC_INTERFACE
  void _resetScores() {
    /// Resets all scores and the board.
    setState(() {
      xScore = 0;
      oScore = 0;
      drawScore = 0;
      _initGame();
    });
  }

  String _playerText(Player p) {
    if (p == Player.X) return 'X';
    if (p == Player.O) return 'O';
    return '';
  }

  Color _markColor(Player p) {
    if (p == Player.X) return kPrimaryColor;
    if (p == Player.O) return kAccentColor;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    // Responsive board sizing (min 300, max 420 for mobile/web)
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final boardSize = shortestSide * 0.8 > 420 ? 420.0 : (shortestSide * 0.8 < 300 ? 300.0 : shortestSide * 0.8);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: _resetScores,
            icon: const Icon(Icons.refresh, color: kSecondaryColor),
            tooltip: 'Reset scores',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 18),
                _scoreBoard(),
                const SizedBox(height: 22),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.05),
                        spreadRadius: 2,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Column(
                    children: [
                      if (!gameOver)
                        Text(
                          "Player ${_playerText(currentPlayer)}'s turn",
                          style: const TextStyle(
                            fontSize: 18,
                            color: kSecondaryColor,
                          ),
                        ),
                      if (gameOver)
                        Text(
                          outcomeMessage,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            letterSpacing: 1,
                            color: kAccentColor,
                          ),
                        ),
                      const SizedBox(height: 16),
                      _ticTacToeBoard(boardSize),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            label: const Text("New Game"),
                            icon: const Icon(Icons.restart_alt),
                            onPressed: _initGame,
                          ),
                          const SizedBox(width: 18),
                          OutlinedButton.icon(
                            label: const Text("Reset Scores"),
                            icon: const Icon(Icons.delete_outline),
                            onPressed: _resetScores,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scoreBoard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor, width: 1),
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _scoreColumn('X', xScore, kPrimaryColor),
          _verticalDivider(),
          _scoreColumn('Draw', drawScore, kSecondaryColor),
          _verticalDivider(),
          _scoreColumn('O', oScore, kAccentColor),
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(
        height: 38,
        width: 1,
        color: Colors.grey[200],
      );

  Widget _scoreColumn(String label, int score, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text('$score',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: kSecondaryColor)),
      ],
    );
  }

  Widget _ticTacToeBoard(double boardSize) {
    return SizedBox(
      width: boardSize,
      height: boardSize,
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          itemCount: 9,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
          padding: EdgeInsets.zero,
          itemBuilder: (context, idx) => _ticTacToeCell(idx),
        ),
      ),
    );
  }

  Widget _ticTacToeCell(int idx) {
    return GestureDetector(
      onTap: () => _handleTap(idx),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: board[idx] == Player.none ? kPrimaryColor.withOpacity(0.18) : _markColor(board[idx]),
            width: board[idx] == Player.none ? 1.3 : 2.0,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: board[idx] != Player.none
              ? [
                  BoxShadow(
                    color: _markColor(board[idx]).withOpacity(0.11),
                    blurRadius: 8,
                    spreadRadius: 0.5,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Text(
              board[idx] == Player.none ? '' : _playerText(board[idx]),
              key: ValueKey(board[idx]),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: _markColor(board[idx]),
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: board[idx] == Player.X
                        ? kPrimaryColor.withOpacity(0.18)
                        : kAccentColor.withOpacity(0.18),
                    offset: const Offset(1, 1.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      child: Center(
        child: Text(
          "Modern Tic Tac Toe • Local Multiplayer",
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
