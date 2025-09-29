class Product {
  final String id;
  final String name;
  final String description;
  final num price;
  final String imageUrl;
  final List<ProductOptionGroup> optionGroups;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.optionGroups = const [],
  });
}

class ProductOptionGroup {
  final String id;
  final String name;
  final bool allowsMultiple;
  final List<ProductOption> options;

  const ProductOptionGroup({
    required this.id,
    required this.name,
    required this.options,
    this.allowsMultiple = false,
  });

  factory ProductOptionGroup.fromMap(Map<String, dynamic> map) {
    return ProductOptionGroup(
      id: map['id'] as String,
      name: map['name'] as String,
      allowsMultiple: map['allowsMultiple'] as bool? ?? false,
      options: (map['options'] as List<dynamic>? ?? [])
          .map((option) => ProductOption.fromMap(option as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductOption {
  final String id;
  final String name;
  final num? price;

  const ProductOption({
    required this.id,
    required this.name,
    this.price,
  });

  factory ProductOption.fromMap(Map<String, dynamic> map) {
    return ProductOption(
      id: map['id'] as String,
      name: map['name'] as String,
      price: map['price'] as num?,
    );
  }
}
