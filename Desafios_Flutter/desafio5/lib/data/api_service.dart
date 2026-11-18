import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/post.dart';

class ApiService {
  Future<List<Post>> getPosts() async {
    final respuesta = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (respuesta.statusCode == 200) {
      final List datos = jsonDecode(respuesta.body);

      return datos.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las noticias');
    }
  }
}