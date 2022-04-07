import 'dart:async';
import 'dart:math';

import 'package:chess_lib/chess_lib.dart';
import 'package:flutter/material.dart';

import 'arrow.dart';
import 'chess_board_animation.dart';
import 'chess_board_style.dart';
import 'chess_square_rendering_details.dart';
import 'decor_layer.dart';
import 'default_style.dart';

class ChessBoardWidget extends StatefulWidget {
  final Player onTop;
  final ChessGameState state;
  late final ChessBoardStyle style;
  late final List<ChessBoardAnimation> animations;
  late final List<Arrow> arrows;
  final void Function(ChessMove)? onPlayMove;
  final void Function()? onAnimationsCompleted;

  ChessBoardWidget(
      {Key? key,
      Player? onTop,
      required this.state,
      ChessBoardStyle? style,
      List<ChessBoardAnimation>? animations,
      List<Arrow>? arrows,
      required this.onPlayMove,
      this.onAnimationsCompleted})
      : onTop = onTop ?? Player.black,
        animations = animations ?? [],
        arrows = arrows ?? [],
        super(key: key) {
    this.style = style ?? defaultChessBoardStyle;
  }

  @override
  State<StatefulWidget> createState() {
    return ChessBoardWidgetState();
  }
}

class _AnimatedMove {
  final ChessMove move;
  final Animation<Alignment> pieceMovement;

  _AnimatedMove(this.move, this.pieceMovement);
}

class ChessBoardWidgetState extends State<ChessBoardWidget>
    with SingleTickerProviderStateMixin {
  Point<int>? tapCoordinates;
  List<ChessMove> validMoves = [];

  late AnimationController controller;
  ChessMove? selectedMove;

  List<_AnimatedMove> animatedMoves = [];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    if (widget.animations.isNotEmpty) {
      int durationMS = widget.animations
          .fold(0, (maxEndMS, a) => a.endMS > maxEndMS ? a.endMS : maxEndMS);
      controller.duration = Duration(milliseconds: durationMS);
      controller.reset();
      for (ChessBoardAnimation animation in widget.animations) {
        animatedMoves.add(createAnimatedMove(animation.move,
            animation.startMS / durationMS, animation.endMS / durationMS));
      }
      controller.forward(from: 0.0).then((value) {
        animatedMoves.clear();
        if (widget.onAnimationsCompleted != null) {
          widget.onAnimationsCompleted!();
        }
      });
    }
  }

  @override
  void didUpdateWidget(ChessBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animations.isNotEmpty) {
      int durationMS = widget.animations
          .fold(0, (maxEndMS, a) => a.endMS > maxEndMS ? a.endMS : maxEndMS);
      controller.duration = Duration(milliseconds: durationMS);
      controller.reset();
      for (ChessBoardAnimation animation in widget.animations) {
        animatedMoves.add(createAnimatedMove(animation.move,
            animation.startMS / durationMS, animation.endMS / durationMS));
      }
      controller.forward(from: 0.0).then((value) {
        animatedMoves.clear();
        if (widget.onAnimationsCompleted != null) {
          widget.onAnimationsCompleted!();
        }
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.0,
        child: LayoutBuilder(
          builder: (context, constraints) =>
              createBoard(constraints.maxWidth / 8.0),
        ));
  }

  Widget createBoard(double squareSize) {
    ChessBoardStyle styleBasedOnSquareSize =
        widget.style.withSquareSize(squareSize);
    List<Widget> items = [];
    for (int y = 0; y < 8; y++) {
      for (int x = 0; x < 8; x++) {
        Alignment alignment =
            Alignment(-1.0 + (x / 7.0) * 2.0, -1.0 + (y / 7.0) * 2.0);
        Point<int> coord =
            widget.onTop == Player.white ? Point(7 - x, y) : Point(x, 7 - y);
        items.add(Align(
            alignment: alignment,
            child: createSquare(styleBasedOnSquareSize, coord, squareSize)));
      }
    }
    for (_AnimatedMove m in animatedMoves) {
      items.add(IgnorePointer(
          child: AnimatedBuilder(
              animation: controller,
              child: styleBasedOnSquareSize.getPieceWidget(m.move.piece),
              builder: (context, child) => Align(
                  alignment: m.pieceMovement.value,
                  child: FractionallySizedBox(
                      widthFactor: 1.0 / 8.0,
                      heightFactor: 1.0 / 8.0,
                      child: child)))));
    }
    if (widget.arrows.isNotEmpty) {
      List<Arrow> arrows = widget.arrows;
      if (widget.onTop == Player.white) {
        arrows = arrows
            .map((e) => Arrow(Point(7 - e.start.x, 7 - e.start.y),
                Point(7 - e.end.x, 7 - e.end.y), e.opacity))
            .toList();
      }
      items.add(Positioned.fill(
          child: DecorLayer(
        arrows: arrows,
      )));
    }
    Widget chessBoardWidget = Stack(
      children: items,
    );
    if (widget.onPlayMove != null) {
      // interactive mode, wrap in gesture detector to clear current interactions
      chessBoardWidget = GestureDetector(
          onTap: () {
            setState(() {
              tapCoordinates = null;
              validMoves.clear();
            });
          },
          child: chessBoardWidget);
    }
    return chessBoardWidget;
  }

  Widget createSquare(ChessBoardStyle style, Point<int> coords, double size) {
    bool isDark = (coords.y + coords.x) % 2 == 0;
    Set<ChessSquareRenderingDetails> squareDetails =
        getRenderingDetails(coords);
    List<Widget> squareContents = [
      style.getSquareWidget(isDark, coords, squareDetails)
    ];
    addSquareDecorations(style, squareDetails, coords, squareContents);
    ChessPiece piece = widget.state.board[coords.y][coords.x];
    if (piece != ChessPiece.none &&
        !animatedMoves.any((am) => am.move.start == coords)) {
      Widget pieceWidget = style.getPieceWidget(piece);
      Widget interactivePieceWidget = pieceWidget;
      if (widget.onPlayMove != null &&
          piece.owner == widget.state.currentPlayer) {
        interactivePieceWidget = Draggable(
            data: piece,
            child: GestureDetector(
              child: interactivePieceWidget,
              onTap: () {
                setState(() {
                  tapCoordinates = coords;
                  validMoves = widget.state.moves
                      .where((m) => m.start == coords)
                      .toList();
                });
              },
            ),
            onDragStarted: () {
              setState(() {
                tapCoordinates = coords;
                validMoves =
                    widget.state.moves.where((m) => m.start == coords).toList();
              });
            },
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                tapCoordinates = null;
                validMoves.clear();
              });
            },
            childWhenDragging: Opacity(
              opacity: 0.5,
              child: pieceWidget,
            ),
            feedback: SizedBox(
              width: size,
              height: size,
              child: pieceWidget,
            ));
      }
      squareContents.add(interactivePieceWidget);
    }

    if (squareDetails.contains(ChessSquareRenderingDetails.possible_move)) {
      List<ChessMove> moves = validMoves.where((m) => m.end == coords).toList();
      squareContents.add(DragTarget<ChessPiece>(
          onAccept: (piece) {
            setState(() {
              if (moves.length > 1) {
                showPromotionModal(moves).then((move) {
                  if (move != null) {
                    widget.onPlayMove!(move);
                  }
                  tapCoordinates = null;
                  validMoves.clear();
                });
                return;
              }
              widget.onPlayMove!(moves.first);
              tapCoordinates = null;
              validMoves.clear();
            });
          },
          builder: (context, candidateData, rejectedData) => GestureDetector(
              onTap: () {
                if (moves.length > 1) {
                  showPromotionModal(moves).then((move) {
                    if (move != null) {
                      animateMove(move);
                    }
                    tapCoordinates = null;
                    validMoves.clear();
                  });
                  return;
                }
                tapCoordinates = null;
                validMoves.clear();
                animateMove(moves.first);
              },
              child: Container(
                width: size,
                height: size,
                color: Colors.transparent,
              ))));
    }

    return SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: squareContents,
        ));
  }

  Set<ChessSquareRenderingDetails> getRenderingDetails(Point<int> c) {
    Set<ChessSquareRenderingDetails> renderingDetails = {};
    if (tapCoordinates == c) {
      renderingDetails.add(ChessSquareRenderingDetails.selected_square);
    }
    if (widget.state.lastMove != null) {
      if (widget.state.lastMove!.start == c) {
        renderingDetails.add(ChessSquareRenderingDetails.last_move_origin);
      } else if (widget.state.lastMove!.end == c) {
        renderingDetails.add(ChessSquareRenderingDetails.last_move_end);
      }
    }
    List<ChessMove> move =
        validMoves.where((element) => element.end == c).toList();
    if (move.isNotEmpty) {
      if (move.first.capture != ChessPiece.none) {
        renderingDetails.add(ChessSquareRenderingDetails.possible_capture);
      }
      renderingDetails.add(ChessSquareRenderingDetails.possible_move);
    }
    ChessPiece piece = widget.state.board[c.y][c.x];
    if (((widget.state.currentPlayer == Player.white &&
                piece == ChessPiece.white_king) ||
            ((widget.state.currentPlayer == Player.black &&
                piece == ChessPiece.black_king))) &&
        widget.state.check) {
      renderingDetails.add(ChessSquareRenderingDetails.king_in_check);
    }
    return renderingDetails;
  }

  void addSquareDecorations(
      ChessBoardStyle style,
      Set<ChessSquareRenderingDetails> squareDetails,
      Point<int> coords,
      List<Widget> currentContents) {
    if (squareDetails.contains(ChessSquareRenderingDetails.possible_capture)) {
      currentContents.add(widget.style.getPossibleCaptureDecor(coords));
    } else if (squareDetails
        .contains(ChessSquareRenderingDetails.possible_move)) {
      currentContents.add(widget.style.getPossibleMoveDecor(coords));
    } else if (squareDetails
        .contains(ChessSquareRenderingDetails.king_in_check)) {
      currentContents.add(widget.style.getKingInCheckDecor(coords));
    }
    if (style.showRankAndFileLabels) {
      bool isDark = (coords.y + coords.x) % 2 == 0;
      if ((widget.onTop == Player.black && coords.x == 0) ||
          (widget.onTop == Player.white && coords.x == 7)) {
        currentContents.add(Align(
            alignment: const Alignment(-.85, -.85),
            child: Text(
              "12345678"[coords.y],
              style: isDark
                  ? style.blackSquareTextStyle
                  : style.whiteSquareTextStyle,
            )));
      }
      if ((widget.onTop == Player.black && coords.y == 0) ||
          (widget.onTop == Player.white && coords.y == 7)) {
        currentContents.add(Align(
          alignment: const Alignment(.85, .85),
          child: Text("abcdefgh"[coords.x],
              style: isDark
                  ? style.blackSquareTextStyle
                  : style.whiteSquareTextStyle),
        ));
      }
    }
  }

  void animateMove(ChessMove m) {
    setState(() {
      controller.reset();
      selectedMove = m;
      controller.duration = const Duration(milliseconds: 170);
      animatedMoves.add(createAnimatedMove(selectedMove!, 0, 1.0));
      controller.forward(from: 0.0).then((value) {
        onSelectedMoveAnimationFinished();
      });
    });
  }

  _AnimatedMove createAnimatedMove(ChessMove m, double i1, double i2) {
    Alignment start = getAlignment(m.start);
    Alignment end = getAlignment(m.end);
    return _AnimatedMove(
        m,
        Tween(begin: start, end: end).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(i1, i2, curve: Curves.easeInOut))));
  }

  Alignment getAlignment(Point<int> c) => Alignment(
      -1.0 + (widget.onTop == Player.black ? c.x : 7.0 - c.x) / 7.0 * 2.0,
      -1.0 + ((widget.onTop == Player.black ? 7.0 - c.y : c.y) / 7.0) * 2.0);

  void onSelectedMoveAnimationFinished() {
    setState(() {
      animatedMoves.clear();
      controller.reset();
      if (selectedMove != null) {
        widget.onPlayMove!(selectedMove!);
        selectedMove = null;
      }
    });
  }

  Future<ChessMove?> showPromotionModal(List<ChessMove> moves) {
    return showDialog(
        context: context,
        builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: moves
                  .map((move) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, move);
                          },
                          child: SizedBox(
                              width: 90,
                              child: widget.style
                                  .getPieceWidget(move.promotion)))))
                  .toList(),
            ));
  }
}
