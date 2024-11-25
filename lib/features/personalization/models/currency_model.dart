class CurrencyModel {
  final String country;
  final String curCode;

  CurrencyModel({
    required this.country,
    required this.curCode,
  });

  @override
  toString() => curCode;
}
