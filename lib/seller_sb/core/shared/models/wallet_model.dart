// Wallet Model للمحفظة والنقاط
class WalletModel {
  final double balance;
  final int points;
  final int traderId;

  WalletModel({
    required this.balance,
    required this.points,
    required this.traderId,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] ?? 0).toDouble(),
      points: json['points'] ?? 0,
      traderId: json['trader_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'points': points,
      'trader_id': traderId,
    };
  }

  @override
  String toString() {
    return 'WalletModel(balance: $balance, points: $points, traderId: $traderId)';
  }
}

// Points Model للنقاط فقط
class PointsModel {
  final int points;

  PointsModel({required this.points});

  factory PointsModel.fromJson(Map<String, dynamic> json) {
    return PointsModel(
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points': points,
    };
  }

  @override
  String toString() {
    return 'PointsModel(points: $points)';
  }
}

// Recharge Result Model
class RechargeResultModel {
  final int pointsAdded;
  final int newBalance;
  final RechargeCode rechargeCode;

  RechargeResultModel({
    required this.pointsAdded,
    required this.newBalance,
    required this.rechargeCode,
  });

  factory RechargeResultModel.fromJson(Map<String, dynamic> json) {
    return RechargeResultModel(
      pointsAdded: json['points_added'] ?? 0,
      newBalance: json['new_balance'] ?? 0,
      rechargeCode: RechargeCode.fromJson(json['recharge_code'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'points_added': pointsAdded,
      'new_balance': newBalance,
      'recharge_code': rechargeCode.toJson(),
    };
  }

  @override
  String toString() {
    return 'RechargeResultModel(pointsAdded: $pointsAdded, newBalance: $newBalance, code: ${rechargeCode.code})';
  }
}

// Recharge Code Model
class RechargeCode {
  final String code;
  final int pointNumber;

  RechargeCode({
    required this.code,
    required this.pointNumber,
  });

  factory RechargeCode.fromJson(Map<String, dynamic> json) {
    return RechargeCode(
      code: json['code'] ?? '',
      pointNumber: json['point_number'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'point_number': pointNumber,
    };
  }

  @override
  String toString() {
    return 'RechargeCode(code: $code, pointNumber: $pointNumber)';
  }
}
