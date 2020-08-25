class Commodity {
  String name;
  int quantity;
  double price;

  Commodity(this.name, this.quantity, {this.price = 100});

  @override
  String toString() {
    return 'Commodity{name: $name, quantity: $quantity, price: $price}';
  }
}
