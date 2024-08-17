class TransactionModel {
  String transactionId;
  String qrCodeId;
  String userId;
  int numOfPlastic;
  int numOfCan;
  int numOfCartons;
  int numOfMiscItems;
  double pointsRedeemed;
  DateTime dateRedeemed;

  TransactionModel({
    required this.transactionId,
    required this.qrCodeId,
    required this.userId,
    required this.numOfPlastic,
    required this.numOfCan,
    required this.numOfCartons,
    required this.numOfMiscItems,
    required this.pointsRedeemed,
    required this.dateRedeemed,
  });
}
