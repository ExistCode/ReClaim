import '../models/item_count.dart';

ItemCount parseMessage(String message) {
  // Split the message by commas
  List<String> parts = message.split(',');

  // Convert the string parts to integers
  int plastic = int.parse(parts[0]);
  int can = int.parse(parts[1]);
  int carton = int.parse(parts[2]);
  

  // Return an instance of ItemCount
  return ItemCount(
    plastic: plastic,
    can: can,
    carton: carton,
    
  );
}
