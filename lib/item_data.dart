class ItemData {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;

  const ItemData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  // Factory constructor to create an ItemData instance from a JSON map
  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json[r'$id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      image: json['image']?.toString() ?? '',
    );
  }

  // Optionally, you can also add a toJson method to convert ItemData back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
