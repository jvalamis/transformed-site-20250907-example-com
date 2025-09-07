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
        domain: 'example.com',
        originalUrl: 'https://example.com/',
        crawledAt: DateTime.now(),
        title: 'Example Domain',
        description: 'This domain is for use in illustrative examples',
        keywords: '',
        pages: [
          PageData(
            url: 'https://example.com/',
            path: '/',
            title: 'Example Domain',
            description: 'This domain is for use in illustrative examples',
            content: PageContentData(
              headings: [
                HeadingData(text: 'Example Domain', level: 1),
              ],
              paragraphs: [
                ParagraphData(
                  text: 'This domain is for use in illustrative examples in documents. You may use this domain in literature without prior coordination or asking for permission.',
                  classes: [],
                ),
                ParagraphData(
                  text: 'More information...',
                  classes: [],
                ),
              ],
              images: [],
              links: [],
              lists: [],
              tables: [],
              forms: [],
              contentBlocks: [],
            ),
          ),
        ],
        assets: [],
      );
      return _websiteData!;
    }
  }

  static void clearCache() {
    _websiteData = null;
  }
}
