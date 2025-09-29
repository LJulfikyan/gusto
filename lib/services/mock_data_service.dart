class MockDataService {
  static final List<Map<String, dynamic>> stores = [
    {
      'id': '1',
      'name': 'Los Amrenios',
      'cuisine': 'Armenio',
      'imageUrl': 'https://scontent.faep24-2.fna.fbcdn.net/v/t39.30808-6/481272153_8944844295645207_1236170266028895483_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=cc71e4&_nc_ohc=NaeYrlxk9nIQ7kNvwFT4Lp4&_nc_oc=Adlt1w-LWgP9PvRqIz0SFNzaLvuddKIcaTijgfqPfCxO8qOR0Vsdc1flzdiqzyeVBRljipAYnPwpb3tLctIuFGLA&_nc_zt=23&_nc_ht=scontent.faep24-2.fna&_nc_gid=RoEzNdL03XI41a6XKKVemw&oh=00_AfaoIe-hc6AZQWIRF3za3J5jxq7eSjP3f0e7YPFNEfI6mQ&oe=68DFCE28',
      'rating': 5.0,
    },
    {
      'id': '2',
      'name': 'McDonalds',
      'cuisine': 'Americana',
      'imageUrl': 'https://s7d1.scene7.com/is/image/mcdonalds/1PUB_EVM_2336x1040:1-column-desktop?resmode=sharp2',
      'rating': 4.2,
    },
    {
      'id': '3',
      'name': 'Sushi a Domicilio',
      'cuisine': 'Japonesa',
      'imageUrl': 'https://sushipopimg.s3.amazonaws.com/carousel/IfgCuVtq1eFB_e9FRg4dtlQEmpH7JNQg.jpg',
      'rating': 4.8,
    },{
      'id': '4',
      'name': 'Los Amrenios',
      'cuisine': 'Armenio',
      'imageUrl': 'https://scontent.faep24-2.fna.fbcdn.net/v/t39.30808-6/481272153_8944844295645207_1236170266028895483_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=cc71e4&_nc_ohc=NaeYrlxk9nIQ7kNvwFT4Lp4&_nc_oc=Adlt1w-LWgP9PvRqIz0SFNzaLvuddKIcaTijgfqPfCxO8qOR0Vsdc1flzdiqzyeVBRljipAYnPwpb3tLctIuFGLA&_nc_zt=23&_nc_ht=scontent.faep24-2.fna&_nc_gid=RoEzNdL03XI41a6XKKVemw&oh=00_AfaoIe-hc6AZQWIRF3za3J5jxq7eSjP3f0e7YPFNEfI6mQ&oe=68DFCE28',
      'rating': 5.0,
    },
    {
      'id': '5',
      'name': 'McDonalds',
      'cuisine': 'Americana',
      'imageUrl': 'https://s7d1.scene7.com/is/image/mcdonalds/1PUB_EVM_2336x1040:1-column-desktop?resmode=sharp2',
      'rating': 4.2,
    },
    {
      'id': '6',
      'name': 'Sushi a Domicilio',
      'cuisine': 'Japonesa',
      'imageUrl': 'https://sushipopimg.s3.amazonaws.com/carousel/IfgCuVtq1eFB_e9FRg4dtlQEmpH7JNQg.jpg',
      'rating': 4.8,
    },{
      'id': '7',
      'name': 'Los Amrenios',
      'cuisine': 'Armenio',
      'imageUrl': 'https://scontent.faep24-2.fna.fbcdn.net/v/t39.30808-6/481272153_8944844295645207_1236170266028895483_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=cc71e4&_nc_ohc=NaeYrlxk9nIQ7kNvwFT4Lp4&_nc_oc=Adlt1w-LWgP9PvRqIz0SFNzaLvuddKIcaTijgfqPfCxO8qOR0Vsdc1flzdiqzyeVBRljipAYnPwpb3tLctIuFGLA&_nc_zt=23&_nc_ht=scontent.faep24-2.fna&_nc_gid=RoEzNdL03XI41a6XKKVemw&oh=00_AfaoIe-hc6AZQWIRF3za3J5jxq7eSjP3f0e7YPFNEfI6mQ&oe=68DFCE28',
      'rating': 5.0,
    },
    {
      'id': '8',
      'name': 'McDonalds',
      'cuisine': 'Americana',
      'imageUrl': 'https://s7d1.scene7.com/is/image/mcdonalds/1PUB_EVM_2336x1040:1-column-desktop?resmode=sharp2',
      'rating': 4.2,
    },
    {
      'id': '9',
      'name': 'Sushi a Domicilio',
      'cuisine': 'Japonesa',
      'imageUrl': 'https://sushipopimg.s3.amazonaws.com/carousel/IfgCuVtq1eFB_e9FRg4dtlQEmpH7JNQg.jpg',
      'rating': 4.8,
    },
  ];

  static final Map<String, List<Map<String, dynamic>>> productsByStore = {
    '1': [
      {
        'id': '101',
        'name': 'Shawarma XL',
        'description': 'Triple carne marinada con especies en pan armenio (lavash) y ensalada de cebolla, tomate, lechuga y salsa de ajo.',
        'price': 12500,
        'imageUrl': 'https://images.rappi.com.ar/restaurants_background/44-1682025549488.jpg',
        'optionGroups': [
          {
            'id': 'sauces',
            'name': 'Salsas adicionales',
            'allowsMultiple': true,
            'options': [
              {
                'id': 'extra_garlic',
                'name': 'Extra salsa de ajo',
                'price': 250,
              },
              {
                'id': 'spicy_touch',
                'name': 'Toque picante',
                'price': 200,
              },
            ],
          },
          {
            'id': 'size',
            'name': 'Tamaño',
            'allowsMultiple': false,
            'options': [
              {
                'id': 'regular',
                'name': 'Regular',
              },
              {
                'id': 'xl',
                'name': 'XL',
                'price': 800,
              },
            ],
          },
        ],
      },
      {
        'id': '102',
        'name': 'Provoleta',
        'description': 'Queso provolone a la parrilla con orégano.',
        'price': 950,
        'imageUrl': 'https://picsum.photos/seed/picsum/200/300',
        'optionGroups': [
          {
            'id': 'toppings',
            'name': 'Extras',
            'allowsMultiple': true,
            'options': [
              {
                'id': 'oregano',
                'name': 'Orégano extra',
                'price': 100,
              },
              {
                'id': 'chimichurri',
                'name': 'Chimichurri',
                'price': 150,
              },
            ],
          },
        ],
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

  static final List<Map<String, dynamic>> orders = [
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
