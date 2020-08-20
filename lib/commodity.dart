class Commodity {
  String name;
  int quantity;

  Commodity(String s, int q) {
    this.name = s;
    this.quantity = q;
  }
  @override
  String toString() {
    return 'Commodity{name: $name, quantity: $quantity}';
  }
}
