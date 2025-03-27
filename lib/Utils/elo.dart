import 'dart:math';

class Elo {
  //TODO: vars to experiment with
  static int initElo = 1500;
  static double weigthSpeed = 0.8;
  static double weigthAccuracy = 0.2;
  static double initT = 1;
  static int tmulti = 10;
  static double alpha = 0.1;
  static int maxK = 40;
  static int thresholdElo = 100;

  static void _updateElo(String user, String skill) {
    //TODO:
  }

  static double _impactFunctionSpeed(double accuracySpeed, double speed) {
    double sign = (1 - speed).sign;
    return sign + speed * accuracySpeed;
  }

  static double _trendFactor(double prevTrendfactor, int actualOutcome,
      int expectedOutcome, double accuracySpeed) {
    //TODO: trendfactor bigger?
    int diffOutcome = actualOutcome - expectedOutcome;
    double impactPrev = (1 - alpha) * prevTrendfactor;
    double impactCorrectnessPrediction =
        alpha * weigthAccuracy * diffOutcome.sign;
    double speedCategory = (accuracySpeed < 0.26)
        ? -1
        : (accuracySpeed > 0.75)
            ? 1
            : 0;
    double impactS = _impactFunctionSpeed(accuracySpeed, speedCategory);
    double impactSpeed = alpha * impactS * speedCategory.sign * weigthSpeed;

    return impactPrev + impactCorrectnessPrediction + impactSpeed;
  }

  static double _calcK(double trendFactor) {
    double absT = trendFactor.abs(); //is absT always between 0 and 1?
    return absT * maxK;
  }

  static double pWin(int eloP1, int eloP2) {
    double exponent = -(eloP1 - eloP2) / 400;
    double denominator = 1 + pow(10, exponent).toDouble();
    return 1 / denominator;
  }

  static List<dynamic> updateElo(int prevElo, int eloComponent, bool won,
      double prevT, double accuracySpeed) {
    int actualOutcome = won ? 1 : -1;
    double chanceWin = pWin(prevElo, eloComponent);
    int expectedOutcome = (chanceWin > 0.5) ? 1 : -1;
    double t =
        _trendFactor(prevT, actualOutcome, expectedOutcome, accuracySpeed);
    double k = _calcK(t) * tmulti;
    int changeElo = (actualOutcome * k * (1 - chanceWin)).toInt();

    int newElo = prevElo + changeElo;

    return [newElo, t];
  }
}
