class ItemCount {
  int plastic;
  int can;
  int carton;
  int miscItems;

  ItemCount({
    required this.plastic,
    required this.can,
    required this.carton,
    required this.miscItems,
  });
}

ItemCount parseMessage(String message) {
  // Split the message by commas
  List<String> parts = message.split(',');

  // Convert the string parts to integers
  int plastic = int.parse(parts[0]);
  int can = int.parse(parts[1]);
  int carton = int.parse(parts[2]);
  int miscItems = int.parse(parts[3]);

  // Return an instance of ItemCount
  return ItemCount(
    plastic: plastic,
    can: can,
    carton: carton,
    miscItems: miscItems,
  );
}
