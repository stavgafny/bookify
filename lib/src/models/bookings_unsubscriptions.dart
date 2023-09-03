class BookingsUnsubscriptions {
  static const empty = BookingsUnsubscriptions({});

  final Set<String> _ids;

  const BookingsUnsubscriptions(this._ids);

  bool getStateOfId(int id) {
    return !_ids.contains(id.toString());
  }

  void setId(String id, bool subscribed) {
    subscribed ? _ids.remove(id) : _ids.add(id);
  }

  List<String> toList() => _ids.toList();

  factory BookingsUnsubscriptions.fromList(List<String> idsList) {
    return BookingsUnsubscriptions(idsList.toSet());
  }

  @override
  String toString() {
    return _ids.toString();
  }
}
