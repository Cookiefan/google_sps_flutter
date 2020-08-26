class Commodity {
  int itemId;
  String name;
  int quantity;
  double price;

  Commodity(this.itemId, this.name, this.quantity, {this.price = 100});

  @override
  String toString() {
    return 'Commodity{item_id: $itemId, name: $name, quantity: $quantity, price: $price}';
  }

  String getImgName() {
    return name.split('\t')[0];
  }
}
