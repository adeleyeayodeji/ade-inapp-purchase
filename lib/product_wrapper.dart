import 'discount.dart';

class Product {
  /// Product Id.
  final String identifier;

  /// Description of the product.
  final String description;

  /// Title of the product.
  final String title;

  /// Price of the product in the local currency.
  final double price;

  /// Formatted price of the item, including its currency sign.
  final String priceString;

  /// Currency code for price and original price.
  final String currencyCode;

  /// Introductory price for product. Can be null.
  final IntroductoryPrice introductoryPrice;

  /// Collection of discount offers for a product. Null for Android.
  final List<Discount> discounts;

  Product.fromJson(Map<dynamic, dynamic> json)
      : identifier = json['identifier'],
        description = json['description'],
        title = json['title'],
        priceString = json['price_string'],
        introductoryPrice =  IntroductoryPrice.fromJson(json),
        currencyCode = json['currency_code'],
        price = json['price'],
        discounts = (json["discounts"] as List<dynamic>)
                .map((item) => Discount.fromJson(item))
                .toList();

  @override
  String toString() {
    return 'Product{identifier: $identifier, description: $description, title: $title, price: $price, priceString: $priceString, currencyCode: $currencyCode, introductoryPrice: $introductoryPrice}';
  }
}

class IntroductoryPrice {
  /// Introductory price of a subscription in the local currency.
  final double introPrice;

  /// Formatted introductory price of a subscription, including
  /// its currency sign, such as €3.99.
  final String introPriceString;

  /// Billing period of the introductory price, specified in
  /// ISO 8601 format.
  final String introPricePeriod;

  /// Unit for the billing period of the introductory price, can be DAY, WEEK,
  /// MONTH or YEAR.
  final String introPricePeriodUnit;

  /// Number of units for the billing period of the introductory price.
  final int introPricePeriodNumberOfUnits;

  /// Number of subscription billing periods for which the
  /// user will be given the introductory price, such as 3.
  final int introPriceCycles;

  IntroductoryPrice.fromJson(Map<dynamic, dynamic> json)
      : introPrice = json['intro_price'] != null ? json['intro_price'].toDouble() : 0.0,
        introPriceString = json['intro_price_string'] != null ? json['intro_price_string'] : "",
        introPricePeriod = json['intro_price_period'] != null ? json['intro_price_period'] : "",
        introPricePeriodUnit = json['intro_price_period_unit'] != null ? json['intro_price_period_unit'] : "",
        introPricePeriodNumberOfUnits =
            json['intro_price_period_number_of_units'] != null ? json['intro_price_period_number_of_units'] : 0,
        introPriceCycles = json['intro_price_cycles'] != null ? json['intro_price_cycles'] : 0;

  @override
  String toString() {
    return 'IntroductoryPrice{introPrice: $introPrice, introPriceString: $introPriceString, introPricePeriod: $introPricePeriod, introPricePeriodUnit: $introPricePeriodUnit, introPricePeriodNumberOfUnits: $introPricePeriodNumberOfUnits, introPriceCycles: $introPriceCycles}';
  }
}
