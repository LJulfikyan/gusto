class MockDataService {
  static final List<dynamic> stores = [
    {
      'id': '1',
      'name': 'La Parrilla de Juan',
      'cuisine': 'Argentina',
      'imageUrl': 'https://picsum.photos/seed/picsum/200/300',
      'rating': 4.5,
    },
    {
      'id': '2',
      'name': 'Pizza Nostra',
      'cuisine': 'Italiana',
      'imageUrl': 'https://picsum.photos/seed/picsum/200/300',
      'rating': 4.2,
    },
    {
      'id': '3',
      'name': 'Sushi a Domicilio',
      'cuisine': 'Japonesa',
      'imageUrl': 'https://picsum.photos/seed/picsum/200/300',
      'rating': 4.8,
    },
  ];

  static final Map<String, List<dynamic>> productsByStore = {
    '1': [
      {
        'id': '101',
        'name': 'Bife de Chorizo',
        'description': 'El clásico corte argentino, jugoso y tierno.',
        'price': 2500.0,
        'imageUrl': 'https://picsum.photos/seed/picsum/200/300',
      },
      {
        'id': '102',
        'name': 'Provoleta',
        'description': 'Queso provolone a la parrilla con orégano.',
        'price': 950.0,
        'imageUrl': 'https://picsum.photos/seed/picsum/200/300',
      },
    ],
    '2': [
      {
        'id': '201',
        'name': 'Pizza Margherita',
        'description': 'La auténtica pizza italiana con tomate, mozzarella y albahaca.',
        'price': 1800.0,
        'imageUrl': 'https://picsum.photos/seed/picsum/200/300',
      },
    ],
    '3': [
      {
        'id': '301',
        'name': 'Tabla de Sushi',
        'description': 'Variedad de piezas de sushi fresco.',
        'price': 3200.0,
        'imageUrl': 'https://picsum.photos/seed/picsum/200/300',
      },
    ],
  };

  static final List<dynamic> orders = [
    {
      'id': '1',
      'items': [
        {
          'product': {
            'id': '101',
            'name': 'Bife de Chorizo',
            'price': 2500.0,
          },
          'quantity': 1,
        }
      ],
      'total': 2500.0,
      'date': DateTime.now().toIso8601String(),
      'status': 'Entregado',
    },
  ];
}
