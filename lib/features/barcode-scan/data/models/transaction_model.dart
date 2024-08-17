class TransactionModel {
  String transactionId;
  String qrCodeId;
  String userId;
  int numOfPlastic;
  int numOfCan;
  int numOfCartons;
  
  double pointsRedeemed;
  DateTime dateRedeemed;

  TransactionModel({
    required this.transactionId,
    required this.qrCodeId,
    required this.userId,
    required this.numOfPlastic,
    required this.numOfCan,
    required this.numOfCartons,
    required this.pointsRedeemed,
    required this.dateRedeemed,
  });
}
