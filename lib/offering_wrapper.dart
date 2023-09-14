import 'package:purchases_flutter/object_wrappers.dart';

/// An offering is a collection of Packages (`Package`) available for the user
/// to purchase. For more info see https://docs.revenuecat.com/docs/entitlements
class Offering {
  /// Unique identifier defined in RevenueCat dashboard.
  final String identifier;

  /// Offering description defined in RevenueCat dashboard.
  final String serverDescription;

  /// Array of `Package` objects available for purchase.
  final List<Package> availablePackages;

  /// Lifetime package type configured in the RevenueCat dashboard, if available.
  final Package lifetime;

  /// Annual package type configured in the RevenueCat dashboard, if available.
  final Package annual;

  /// Six month package type configured in the RevenueCat dashboard, if available.
  final Package sixMonth;

  /// Three month package type configured in the RevenueCat dashboard, if available.
  final Package threeMonth;

  /// Two month package type configured in the RevenueCat dashboard, if available.
  final Package twoMonth;

  /// Monthly package type configured in the RevenueCat dashboard, if available.
  final Package monthly;

  /// Weekly package type configured in the RevenueCat dashboard, if available.
  final Package weekly;

  Offering.fromJson(Map<dynamic, dynamic> map)
      : identifier = map["identifier"],
        serverDescription = map['serverDescription'],
        availablePackages = (map['availablePackages'] as List<dynamic>)
            .map((item) => Package.fromJson(item))
            .toList(),
        lifetime =
             Package.fromJson(map['lifetime']),
        annual =  Package.fromJson(map["annual"]) ,
        sixMonth =
            Package.fromJson(map["sixMonth"]) ,
        threeMonth = Package.fromJson(map["threeMonth"]),
        twoMonth =
            Package.fromJson(map["twoMonth"]),
        monthly = Package.fromJson(map["monthly"]),
        weekly = Package.fromJson(map["weekly"]);

  /// Retrieves a specific package by identifier, use this to access custom
  /// package types configured in the RevenueCat dashboard.
  Package getPackage(String identifier) {
    return availablePackages.firstWhere(
        (package) => package.identifier == identifier,
        orElse: () => throw ArgumentError(
            "Package $identifier is not part of the available packages"));
  }

  @override
  String toString() {
    return 'Offering{identifier: $identifier, serverDescription: $serverDescription, availablePackages: $availablePackages, lifetime: $lifetime, annual: $annual, sixMonth: $sixMonth, threeMonth: $threeMonth, twoMonth: $twoMonth, monthly: $monthly, weekly: $weekly}';
  }
}
