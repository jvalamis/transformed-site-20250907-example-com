import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/website_data.dart';

class DataService {
  static WebsiteData? _websiteData;
  
  static Future<WebsiteData> loadWebsiteData() async {
    if (_websiteData != null) {
      return _websiteData!;
    }

    try {
      // Try to load from assets first (for development)
      final String jsonString = await rootBundle.loadString('assets/site-data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _websiteData = WebsiteData.fromJson(jsonData);
      return _websiteData!;
    } catch (e) {
      // If not found in assets, try to load from the web
      try {
        // Use Uri.base.resolve to respect the base href (GitHub Pages repo path)
        final url = Uri.base.resolve('site-data.json');
        
        final response = await http.get(
          url, 
          headers: {
            'Cache-Control': 'no-cache',
            'Accept': 'application/json',
          }
        );
        
        if (response.statusCode == 200) {
          final String responseBody = response.body;
          if (responseBody.isEmpty) {
            throw Exception('Empty response from $url');
          }
          
          final Map<String, dynamic> jsonData = json.decode(responseBody);
          _websiteData = WebsiteData.fromJson(jsonData);
          return _websiteData!;
        } else {
          throw Exception('GET $url -> ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Failed to load website data: $e');
      }
    }
  }

  static void clearCache() {
    _websiteData = null;
  }
}
