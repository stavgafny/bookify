import 'dart:convert';

class BookingModel {
  final int id;
  final String name;
  final DateTime checkinDate;
  final DateTime checkoutDate;
  final DateTime lastDateToCancel;
  final num startRoomPrice;
  final num priceNotifier;
  final num? lastPrice;
  final DateTime lastUpdateDate;

  BookingModel({
    required this.id,
    required this.name,
    required this.checkinDate,
    required this.checkoutDate,
    required this.lastDateToCancel,
    required this.startRoomPrice,
    required this.priceNotifier,
    required this.lastPrice,
    required this.lastUpdateDate,
  });

  BookingModel copyWith({
    int? id,
    String? name,
    DateTime? checkinDate,
    DateTime? checkoutDate,
    DateTime? lastDateToCancel,
    num? startRoomPrice,
    num? priceNotifier,
    num? lastPrice,
    DateTime? lastUpdateDate,
  }) {
    return BookingModel(
      id: id ?? this.id,
      name: name ?? this.name,
      checkinDate: checkinDate ?? this.checkinDate,
      checkoutDate: checkoutDate ?? this.checkoutDate,
      lastDateToCancel: lastDateToCancel ?? this.lastDateToCancel,
      startRoomPrice: startRoomPrice ?? this.startRoomPrice,
      priceNotifier: priceNotifier ?? this.priceNotifier,
      lastPrice: lastPrice ?? this.lastPrice,
      lastUpdateDate: lastUpdateDate ?? this.lastUpdateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'checkinDate': checkinDate.millisecondsSinceEpoch,
      'checkoutDate': checkoutDate.millisecondsSinceEpoch,
      'lastDateToCancel': lastDateToCancel.millisecondsSinceEpoch,
      'startRoomPrice': startRoomPrice,
      'priceNotifier': priceNotifier,
      'lastPrice': lastPrice,
      'lastUpdateDate': lastUpdateDate.millisecondsSinceEpoch,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] as int,
      name: map['name'] as String,
      checkinDate:
          DateTime.fromMillisecondsSinceEpoch(map['checkinDate'] as int),
      checkoutDate:
          DateTime.fromMillisecondsSinceEpoch(map['checkoutDate'] as int),
      lastDateToCancel:
          DateTime.fromMillisecondsSinceEpoch(map['lastDateToCancel'] as int),
      startRoomPrice: map['startRoomPrice'] as num,
      priceNotifier: map['priceNotifier'] as num,
      lastPrice: map['lastPrice'] != null ? map['lastPrice'] as num : null,
      lastUpdateDate:
          DateTime.fromMillisecondsSinceEpoch(map['lastUpdateDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingModel.fromJson(String source) =>
      BookingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookingModel(id: $id, name: $name, checkinDate: $checkinDate, checkoutDate: $checkoutDate, lastDateToCancel: $lastDateToCancel, startRoomPrice: $startRoomPrice, priceNotifier: $priceNotifier, lastPrice: $lastPrice, lastUpdateDate: $lastUpdateDate)';
  }

  @override
  bool operator ==(covariant BookingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.checkinDate == checkinDate &&
        other.checkoutDate == checkoutDate &&
        other.lastDateToCancel == lastDateToCancel &&
        other.startRoomPrice == startRoomPrice &&
        other.priceNotifier == priceNotifier &&
        other.lastPrice == lastPrice &&
        other.lastUpdateDate == lastUpdateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        checkinDate.hashCode ^
        checkoutDate.hashCode ^
        lastDateToCancel.hashCode ^
        startRoomPrice.hashCode ^
        priceNotifier.hashCode ^
        lastPrice.hashCode ^
        lastUpdateDate.hashCode;
  }
}
