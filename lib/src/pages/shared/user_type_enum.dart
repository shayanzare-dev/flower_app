
enum UserType {
  vendor(
    value: 1,
    name: 'vendor',
  ),
  customer(
    value: 2,
    name: 'customer',
  ),
  none(
    value: 0,
    name: 'none',
  );

  const UserType({
    required this.value,
    required this.name,
  });

  final int value;
  final String name;

  static UserType getUserTypeFromValue(int value) {
    if (value == 1) return UserType.vendor;
    if (value == 2) return UserType.customer;
    return UserType.none;
  }
}
