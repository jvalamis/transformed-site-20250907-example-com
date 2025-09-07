import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/website_data.dart';

class DataService {
  static WebsiteData? _websiteData;
  
  static Future<WebsiteData> loadWebsiteData() async {
    if (_websiteData != null) {
      return _websiteData!;
    }

    try {
      // Load from assets (the site-data.json file is copied to assets during build)
      final String jsonString = await rootBundle.loadString('assets/site-data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      _websiteData = WebsiteData.fromJson(jsonData);
      return _websiteData!;
    } catch (e) {
      // If loading fails, create a fallback data structure
      _websiteData = WebsiteData(
        metadata: WebsiteMetadata(
          domain: 'example.com',
          baseUrl: 'https://example.com/',
          totalPages: 1,
          totalAssets: 0,
          crawledAt: DateTime.now().toIso8601String(),
          title: 'Example Domain',
          description: 'This domain is for use in illustrative examples',
          keywords: '',
        ),
        pages: [
          WebsitePage(
            url: 'https://example.com/',
            title: 'Example Domain',
            content: [
              ContentBlock(
                type: 'heading',
                level: 1,
                text: 'Example Domain',
              ),
              ContentBlock(
                type: 'paragraph',
                text: 'This domain is for use in illustrative examples in documents. You may use this domain in literature without prior coordination or asking for permission.',
              ),
              ContentBlock(
                type: 'paragraph',
                text: 'More information...',
              ),
            ],
            images: [],
            links: [],
          ),
        ],
        assets: [],
        navigation: [],
      );
      return _websiteData!;
    }
  }

  static void clearCache() {
    _websiteData = null;
  }
}
