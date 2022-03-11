import 'dart:math';

import 'package:chess_lib/chess_lib.dart';
import 'package:flutter/material.dart';

import 'chess-square-rendering-details.dart';

class ChessBoardStyle {
  final Widget Function(ChessPiece) getPieceWidget;
  final Widget Function(
          bool dark, Point<int>, Set<ChessSquareRenderingDetails> details)
      getSquareWidget;
  final TextStyle whiteSquareTextStyle;
  final TextStyle blackSquareTextStyle;
  final bool showRankAndFileLabels;

  ChessBoardStyle(
      {required this.getPieceWidget,
      required this.getSquareWidget,
      required this.whiteSquareTextStyle,
      required this.blackSquareTextStyle,
      required this.showRankAndFileLabels});

  ChessBoardStyle copyWith({
    Widget Function(ChessPiece)? getPieceWidget,
    Widget Function(
            bool dark, Point<int>, Set<ChessSquareRenderingDetails> details)?
        getSquareWidget,
    TextStyle? whiteSquareTextStyle,
    TextStyle? blackSquareTextStyle,
    bool? showRankAndFileLabels,
  }) {
    return ChessBoardStyle(
        getPieceWidget: getPieceWidget ?? this.getPieceWidget,
        getSquareWidget: getSquareWidget ?? this.getSquareWidget,
        whiteSquareTextStyle: whiteSquareTextStyle ?? this.whiteSquareTextStyle,
        blackSquareTextStyle: blackSquareTextStyle ?? this.blackSquareTextStyle,
        showRankAndFileLabels:
            showRankAndFileLabels ?? this.showRankAndFileLabels);
  }

  double _getGoodFontSizeForSquareSize(double size) {
    List<List<double>> sizings = [
      [70, 8],
      [80, 12],
      [90, 14],
      [100, 16]
    ];
    double lastSize = 0;
    for (List<double> sizing in sizings) {
      if (size > lastSize && size < sizing[0]) {
        return sizing[1];
      }
      lastSize = sizing[0];
    }
    return 18.0;
  }

  ChessBoardStyle withSquareSize(double size) {
    if (size < 60) {
      return copyWith(showRankAndFileLabels: false);
    }
    return copyWith(
        whiteSquareTextStyle: whiteSquareTextStyle.copyWith(
            fontSize: _getGoodFontSizeForSquareSize(size)),
        blackSquareTextStyle: blackSquareTextStyle.copyWith(
            fontSize: _getGoodFontSizeForSquareSize(size)));
  }
}
