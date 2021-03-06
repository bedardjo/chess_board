import 'dart:math';

import 'package:chess_board_widget/src/check_decor_drawer.dart';
import 'package:chess_board_widget/src/possible_capture_drawer.dart';
import 'package:chess_lib/chess_lib.dart';
import 'package:flutter/material.dart';

import 'chess_board_style.dart';
import 'chess_square_rendering_details.dart';

ChessBoardStyle defaultChessBoardStyle = ChessBoardStyle(
    getPieceWidget: (piece) {
      switch (piece) {
        case ChessPiece.white_pawn:
          return const Image(
            image: AssetImage("assets/default_board/white_pawn.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.white_bishop:
          return const Image(
            image: AssetImage("assets/default_board/white_bishop.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.white_knight:
          return const Image(
            image: AssetImage("assets/default_board/white_knight.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.white_rook:
          return const Image(
            image: AssetImage("assets/default_board/white_rook.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.white_queen:
          return const Image(
            image: AssetImage("assets/default_board/white_queen.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.white_king:
          return const Image(
            image: AssetImage("assets/default_board/white_king.png",
                package: 'chess_board_widget'),
          );

        case ChessPiece.black_pawn:
          return const Image(
            image: AssetImage("assets/default_board/black_pawn.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.black_bishop:
          return const Image(
            image: AssetImage("assets/default_board/black_bishop.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.black_knight:
          return const Image(
            image: AssetImage("assets/default_board/black_knight.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.black_rook:
          return const Image(
            image: AssetImage("assets/default_board/black_rook.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.black_queen:
          return const Image(
            image: AssetImage("assets/default_board/black_queen.png",
                package: 'chess_board_widget'),
          );
        case ChessPiece.black_king:
          return const Image(
            image: AssetImage("assets/default_board/black_king.png",
                package: 'chess_board_widget'),
          );

        case ChessPiece.none:
          return const SizedBox();
      }
    },
    getSquareWidget: (bool dark, Point<int> coord,
        Set<ChessSquareRenderingDetails> details) {
      if (dark) {
        if (details.contains(ChessSquareRenderingDetails.selected_square)) {
          return Container(
            color: const Color.fromARGB(255, 100, 109, 64),
          );
        } else if (details
                .contains(ChessSquareRenderingDetails.last_move_origin) ||
            details.contains(ChessSquareRenderingDetails.last_move_end)) {
          return Container(
            color: const Color.fromARGB(255, 171, 162, 58),
          );
        }
        return Container(
          color: const Color.fromARGB(255, 181, 136, 99),
        );
      } else {
        if (details.contains(ChessSquareRenderingDetails.selected_square)) {
          return Container(
            color: const Color.fromARGB(255, 129, 150, 105),
          );
        } else if (details
                .contains(ChessSquareRenderingDetails.last_move_origin) ||
            details.contains(ChessSquareRenderingDetails.last_move_end)) {
          return Container(
            color: const Color.fromARGB(255, 206, 210, 107),
          );
        }
        return Container(
          color: const Color.fromARGB(255, 240, 217, 181),
        );
      }
    },
    getPossibleCaptureDecor: (coord) => Positioned.fill(
            child: CustomPaint(
          painter: PossibleCaptureDrawer(),
        )),
    getPossibleMoveDecor: (coord) => Align(
        alignment: Alignment.center,
        child: FractionallySizedBox(
            widthFactor: .25,
            heightFactor: .25,
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(.25))))),
    getKingInCheckDecor: (coord) => Positioned.fill(
            child: CustomPaint(
          painter: CheckDecorDrawer(),
        )),
    whiteSquareTextStyle: const TextStyle(
        color: Color.fromARGB(255, 181, 136, 99),
        fontSize: 16,
        fontWeight: FontWeight.w600),
    blackSquareTextStyle: const TextStyle(
        color: Color.fromARGB(255, 240, 217, 181),
        fontSize: 16,
        fontWeight: FontWeight.w600),
    showRankAndFileLabels: true);
