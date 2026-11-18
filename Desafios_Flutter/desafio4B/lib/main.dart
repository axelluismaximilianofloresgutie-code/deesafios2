import 'models/user.dart';

void main() {
  List<Map<String, dynamic>> datosJson = [
    {
      'id': 1,
      'name': 'Leanne Graham',
      'username': 'Bret',
      'email': 'Sincere@april.biz',
      'address': {
        'city': 'Gwenborough',
        'zipcode': '92998-3874',
      },
    },
    {
      'id': 2,
      'name': 'Ervin Howell',
      'username': 'Antonette',
      'email': 'Shanna@example.com',
      'address': {
        'city': 'Wisokyburgh',
        'zipcode': '90566-7771',
      },
    },
  ];

  List<User> usuarios = datosJson.map((json) {
    return User.fromJson(json);
  }).toList();

  for (var usuario in usuarios) {
    print('Nombre: ${usuario.name}');
    print('Email: ${usuario.email}');
    print('Ciudad: ${usuario.city}');
    print('Código postal: ${usuario.zipcode}');
    print('----------------');
  }
}