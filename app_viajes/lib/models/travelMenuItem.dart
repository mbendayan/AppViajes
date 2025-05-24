class TravelMenuItem {
  final String title;
  final String destination;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String price;
  final String code;

  const TravelMenuItem({
    required this.title,
    required this.destination,
    required this.dateStart,
    required this.dateEnd,
    required this.price,
    required this.code,
  });
}

final List<TravelMenuItem> travelMenuItems = [
  TravelMenuItem(
    title: "Aventura en la Patagonia",
    destination: "Torres del Paine, Chile",
    dateStart: DateTime(2025, 6, 15),
    dateEnd: DateTime(2025, 6, 25),
    price: "\$1,500",
    code: "1234",
  ),
  TravelMenuItem(
    title: "Escapada a la Toscana",
    destination: "Florencia, Italia",
    dateStart: DateTime(2025, 9, 1),
    dateEnd: DateTime(2025, 9, 10),
    price: "\$2,300",
    code: "12345",
  ),
  TravelMenuItem(
    title: "Safari en Kenia",
    destination: "Parque Nacional de Masái Mara, Kenia",
    dateStart: DateTime(2025, 7, 10),
    dateEnd: DateTime(2025, 7, 20),
    price: "\$3,200",
    code: "123",
  ),
  TravelMenuItem(
    title: "Crucero por el Caribe",
    destination: "Bahamas y Jamaica",
    dateStart: DateTime(2025, 8, 5),
    dateEnd: DateTime(2025, 8, 12),
    price: "\$2,000",
    code: "123423",
  ),
  TravelMenuItem(
    title: "Descubre Japón",
    destination: "Tokio y Kioto, Japón",
    dateStart: DateTime(2025, 10, 1),
    dateEnd: DateTime(2025, 10, 15),
    price: "\$4,500",
    code: "1234343",
  ),
  TravelMenuItem(
    title: "Relax en Maldivas",
    destination: "Islas Maldivas",
    dateStart: DateTime(2025, 12, 20),
    dateEnd: DateTime(2025, 12, 30),
    price: "\$5,000",
    code: "1233434",
  ),
];
