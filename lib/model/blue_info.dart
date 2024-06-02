import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BlueInfoModel {
  late DeviceIdentifier remoteId;
  String? advName;
  bool? isConnect;
  int? connectMode;
  String? uuid;
  List<CharacteristicList>? characteristicList;

  BlueInfoModel({
    required this.remoteId,
    required this.advName,
    this.isConnect = false,
    required this.connectMode,
    // required this.uuid,
    // required this.characteristicList,
  });

  BlueInfoModel.fromJson(Map<String, dynamic> json) {
    remoteId = json['remoteId'];
    advName = json['advName'];
    isConnect = json['isConnect'];
    connectMode = json['connectMode'];
    uuid = json['uuid'];
    if (json['characteristicList'] != null) {
      characteristicList = <CharacteristicList>[];
      json['characteristicList'].forEach((v) {
        characteristicList!.add(CharacteristicList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['remoteId'] = remoteId;
    data['advName'] = advName;
    data['isConnect'] = isConnect;
    data['connectMode'] = connectMode;
    data['uuid'] = uuid;
    if (characteristicList != null) {
      data['characteristicList'] =
          characteristicList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'BlueInfoModel{remoteId: $remoteId, advName: $advName, isConnect: $isConnect, connectMode: $connectMode, uuid: $uuid, characteristicList: $characteristicList}';
  }
}

class CharacteristicList {
  late Guid serviceUuid;
  List<Characteristics>? characteristics;

  // CharacteristicList({required this.serviceUuid, required this.characteristics});
  CharacteristicList({required this.serviceUuid, this.characteristics});

  CharacteristicList.fromJson(Map<String, dynamic> json) {
    serviceUuid = json['serviceUuid'];
    if (json['characteristics'] != null) {
      characteristics = <Characteristics>[];
      json['characteristics'].forEach((v) {
        characteristics!.add(Characteristics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['serviceUuid'] = serviceUuid;
    if (characteristics != null) {
      data['characteristics'] =
          characteristics!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'CharacteristicList{serviceUuid: $serviceUuid, characteristics: $characteristics}';
  }
}

class Characteristics {
  late Guid characteristicUuid;
  Map<String, bool>? properties;
  List<Descriptors>? descriptors;
  List<int>? value;

  Characteristics(
      {required this.characteristicUuid,
      required this.properties,
      required this.descriptors,
      this.value});

  Characteristics.fromJson(Map<String, dynamic> json) {
    characteristicUuid = json['characteristicUuid'];
    properties = json['properties'];
    if (json['descriptors'] != null) {
      descriptors = <Descriptors>[];
      json['descriptors'].forEach((v) {
        descriptors!.add(Descriptors.fromJson(v));
      });
    }
    value = json['value']?.cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['characteristicUuid'] = characteristicUuid;
    data['properties'] = properties;
    if (descriptors != null) {
      data['descriptors'] = descriptors!.map((v) => v.toJson()).toList();
    }
    data['value'] = value;
    return data;
  }

  @override
  String toString() {
    return 'Characteristics{characteristicUuid: $characteristicUuid, properties: $properties, descriptors: $descriptors, value: $value}';
  }
}

/*class Properties {
  bool? read;
  bool? writeWithoutResponse;
  bool? write;
  bool? notify;

  Properties({
    this.read,
    this.writeWithoutResponse,
    this.write,
    this.notify,
  });

  Properties.fromJson(Map<String, dynamic> json) {
    if (json['read'] == true) read = true;
    if (json['writeWithoutResponse'] == true) writeWithoutResponse = true;
    if (json['write'] == true) write = true;
    if (json['notify'] == true) notify = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (read == true) data['read'] = read;
    if (writeWithoutResponse == true) {
      data['writeWithoutResponse'] = writeWithoutResponse;
    }
    if (write == true) data['write'] = write;
    if (notify == true) data['notify'] = notify;
    return data;
  }

  @override
  String toString() {
    return 'Properties{read: $read, writeWithoutResponse: $writeWithoutResponse, write: $write, notify: $notify}';
  }
}*/
/*class Properties {
  bool? read;
  bool? writeWithoutResponse;
  bool? write;
  bool? notify;

  Properties({
    required this.read,
    required this.writeWithoutResponse,
    required this.write,
    required this.notify,
  });

  Properties.fromJson(Map<String, dynamic> json) {
    // broadcast = json['broadcast'];
    read = json['read'];
    writeWithoutResponse = json['writeWithoutResponse'];
    write = json['write'];
    notify = json['notify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    // data['broadcast'] = broadcast;
    data['read'] = read;
    data['writeWithoutResponse'] = writeWithoutResponse;
    data['write'] = write;
    data['notify'] = notify;
    return data;
  }

  @override
  String toString() {
    return 'Properties{read: $read, writeWithoutResponse: $writeWithoutResponse, write: $write, notify: $notify}';
  }
}*/

class Descriptors {
  late Guid descriptorUuid;
  List<int>? lastValue;

  Descriptors({required this.descriptorUuid, this.lastValue});

  Descriptors.fromJson(Map<String, dynamic> json) {
    descriptorUuid = json['descriptorUuid'];
    lastValue = json['lastValue'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['descriptorUuid'] = descriptorUuid;
    data['lastValue'] = lastValue;
    return data;
  }

  @override
  String toString() {
    return 'Descriptors{descriptorUuid: $descriptorUuid, lastValue: $lastValue}';
  }
}
