import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BlueCharacteristicModel {
  final DeviceIdentifier remoteId;
  final Guid serviceUuid;
  final Guid characteristicUuid;

  // String secondaryServiceUuid;

  BlueCharacteristicModel({
    required this.remoteId,
    required this.serviceUuid,
    required this.characteristicUuid,
  });

  @override
  String toString() {
    return 'BlueCharacteristic{remoteId: $remoteId, serviceUuid: $serviceUuid, characteristicUuid: $characteristicUuid}';
  }
}
