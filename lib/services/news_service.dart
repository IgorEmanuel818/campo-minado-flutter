import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  final String apiKey = "1300a7e5d78f4307a495dc1c1b5208ea";

  Future<List<dynamic>> getTopHeadlines() async {
    // Busca ampla, sem filtro de país ou idioma
    final url = Uri.parse(
      "https://newsapi.org/v2/everything?q=news&apiKey=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final articles = data["articles"] as List<dynamic>? ?? [];
      return articles;
    } else {
      throw Exception("Erro ao carregar notícias");
    }
  }
}