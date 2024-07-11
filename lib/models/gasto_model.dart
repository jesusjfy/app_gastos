class GastoModel {
  int id;
  String title;
  double price;
  String datetime;
  String type;

  GastoModel({
    required this.id,
    required this.title,
    required this.price,
    required this.datetime,
    required this.type,
  });

  factory GastoModel.fromDB(Map<String, dynamic> data) => GastoModel(
        id: data["id"],
        title: data["title"],
        price: data["price"],
        datetime: data["datetime"],
        type: data["type"],
      );

  Map<String, dynamic> convertiraMap() => {
        "title": title,
        "price": price,
        "datetime": datetime,
        "type": type,
      };
}