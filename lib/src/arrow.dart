import 'dart:math';

class Arrow {
  final Point<int> start;
  final Point<int> end;
  final double opacity;

  bool get isKnightMove {
    int xDiff = (end.x - start.x).abs();
    int yDiff = (end.y - start.y).abs();
    return xDiff == 2 && yDiff == 1 || xDiff == 1 && yDiff == 2;
  }

  Arrow(this.start, this.end, this.opacity);
}
