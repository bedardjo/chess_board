# chess_board

This package is for drawing styled chess boards. Default styles are provided, which resemble lichess boards, but the style can also be easily overridden. For a better user experience, niceties are provided like piece movement animations and square decorations. This package uses the `chess_lib` package for handling the modelling of chess and its rules.

## Getting started

To import:

```dart
import 'package:chess_board_widget/chess_board_widget.dart';
```

An example usage is as follows:

```dart
class ExampleUsage extends StatefulWidget {
  const ExampleUsage({Key? key}) : super(key: key);

  @override
  State<ExampleUsage> createState() => ExampleUsageState();
}

class ExampleUsageState extends State<ExampleUsage> {
  ChessGameState state = ChessGameState.initialBoardPosition();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChessBoardWidget(
        state: state,
        onPlayMove: (move) {
          setState(() {
            state = state.playMove(move);
          });
        },
      ),
    );
  }
}
```
