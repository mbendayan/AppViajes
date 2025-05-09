import 'package:app_viajes/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UserNotifier extends StateNotifier<User> {
  UserNotifier(super._state);

  Future<void> login(String usuario, String clave) async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      final response = await http.get(url);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  Future<void> register(User user) async {
    /*try {
      await doc.set(movie.toFirestore());
      state = [...state, movie];
    } catch (e) {
      print(e);
    }*/
  }
}
