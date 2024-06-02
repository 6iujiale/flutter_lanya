class BlueExampleModel {
  String imageUrl;
  final String advName;
  final String remoteId;
  final String uuid;

  BlueExampleModel(
      {this.imageUrl =
          "https://pic3.zhimg.com/v2-d008e59532b052f4a8ee2ddb45222906_1440w.jpg?source=172ae18b",
      required this.advName,
      required this.remoteId,
      required this.uuid});

  @override
  String toString() {
    return 'BlueExampleModel{imageUrl: $imageUrl, advName: $advName, remoteId: $remoteId, uuid: $uuid}';
  }
}
