class ChainContract {
  ChainContract({
    required this.address,
    this.blockCreated,
  });

  factory ChainContract.fromMap(Map<String, dynamic> map) {
    var actualMap = map;
    if (map.length == 1 && map.values.first is Map<String, dynamic>) {
      actualMap = map.values.first as Map<String, dynamic>;
    }
    return ChainContract(
      address: actualMap['address'],
      blockCreated: actualMap['blockCreated'],
    );
  }

  String address;
  int? blockCreated;
}
