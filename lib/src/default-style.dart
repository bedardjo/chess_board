import 'package:chess_lib/chess_lib.dart';
import 'package:flutter/material.dart';

import 'chess-board-style.dart';

ChessBoardStyle defaultStyle = ChessBoardStyle(
    getPieceWidget: (piece) {
      switch (piece) {
        case ChessPiece.white_pawn:
          return Image(
            image: AssetImage("assets/default_board/white_pawn.png"),
          );
        case ChessPiece.white_bishop:
          return Image(
            image: AssetImage("assets/default_board/white_bishop.png"),
          );
        case ChessPiece.white_knight:
          return Image(
            image: AssetImage("assets/default_board/white_knight.png"),
          );
        case ChessPiece.white_rook:
          return Image(
            image: AssetImage("assets/default_board/white_rook.png"),
          );
        case ChessPiece.white_queen:
          return Image(
            image: AssetImage("assets/default_board/white_queen.png"),
          );
        case ChessPiece.white_king:
          return Image(
            image: AssetImage("assets/default_board/white_king.png"),
          );

        case ChessPiece.black_pawn:
          return Image(
            image: AssetImage("assets/default_board/black_pawn.png"),
          );
        case ChessPiece.black_bishop:
          return Image(
            image: AssetImage("assets/default_board/black_bishop.png"),
          );
        case ChessPiece.black_knight:
          return Image(
            image: AssetImage("assets/default_board/black_knight.png"),
          );
        case ChessPiece.black_rook:
          return Image(
            image: AssetImage("assets/default_board/black_rook.png"),
          );
        case ChessPiece.black_queen:
          return Image(
            image: AssetImage("assets/default_board/black_queen.png"),
          );
        case ChessPiece.black_king:
          return Image(
            image: AssetImage("assets/default_board/black_king.png"),
          );

        case ChessPiece.none:
          return SizedBox();
      }
    },
    getSquareWidget: (bool dark, Point<int> coord,
        Set<ChessSquareRenderingDetails> details) {
      if (dark) {
        if (details.contains(ChessSquareRenderingDetails.selected_square)) {
          return Container(
            color: Color.fromARGB(255, 100, 109, 64),
          );
        } else if (details
                .contains(ChessSquareRenderingDetails.last_move_origin) ||
            details.contains(ChessSquareRenderingDetails.last_move_end)) {
          return Container(
            color: Color.fromARGB(255, 171, 162, 58),
          );
        }
        return Container(
          color: Color.fromARGB(255, 181, 136, 99),
        );
      } else {
        if (details.contains(ChessSquareRenderingDetails.selected_square)) {
          return Container(
            color: Color.fromARGB(255, 129, 150, 105),
          );
        } else if (details
                .contains(ChessSquareRenderingDetails.last_move_origin) ||
            details.contains(ChessSquareRenderingDetails.last_move_end)) {
          return Container(
            color: Color.fromARGB(255, 206, 210, 107),
          );
        }
        return Container(
          color: Color.fromARGB(255, 240, 217, 181),
        );
      }
    },
    whiteSquareTextStyle: TextStyle(
        color: Color.fromARGB(255, 181, 136, 99),
        fontSize: 16,
        fontWeight: FontWeight.w600),
    blackSquareTextStyle: TextStyle(
        color: Color.fromARGB(255, 240, 217, 181),
        fontSize: 16,
        fontWeight: FontWeight.w600),
    showRankAndFileLabels: true);
