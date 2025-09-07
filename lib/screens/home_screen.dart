import 'package:flutter/material.dart';
import '../models/website_data.dart';
import '../services/data_service.dart';
import '../widgets/adaptive_navigation.dart';
import '../widgets/responsive_image.dart';
import '../utils/responsive_layout.dart';
import 'page_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebsiteData? _websiteData;
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await DataService.loadWebsiteData();
      setState(() {
        _websiteData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_websiteData == null) {
      return _buildEmptyState();
    }

    return AdaptiveNavigation(
      pages: _websiteData!.pages,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      body: _buildBody(),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: ResponsiveLayout.spacing16),
            Text(
              'Loading content...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveLayout.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              SizedBox(height: ResponsiveLayout.spacing16),
              Text(
                'Error loading data',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveLayout.spacing8),
              Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveLayout.spacing24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: ResponsiveLayout.spacing16),
            Text(
              'No content available',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveLayout.spacing16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: ResponsiveLayout.maxContentWidth,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: ResponsiveLayout.spacing32),
            _buildContentPreview(),
            SizedBox(height: ResponsiveLayout.spacing32),
            _buildPagesGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _websiteData!.title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (_websiteData!.description.isNotEmpty) ...[
          SizedBox(height: ResponsiveLayout.spacing8),
          Text(
            _websiteData!.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
        if (_websiteData!.keywords.isNotEmpty) ...[
          SizedBox(height: ResponsiveLayout.spacing12),
          Wrap(
            spacing: ResponsiveLayout.spacing8,
            runSpacing: ResponsiveLayout.spacing4,
            children: _websiteData!.keywords
                .split(',')
                .map((keyword) => Chip(
                      label: Text(keyword.trim()),
                      visualDensity: VisualDensity.compact,
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildContentPreview() {
    final totalImages = _websiteData!.pages
        .fold(0, (sum, page) => sum + page.content.images.length);
    final totalLinks = _websiteData!.pages
        .fold(0, (sum, page) => sum + page.content.links.length);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveLayout.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: ResponsiveLayout.spacing16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.pages,
                    label: 'Pages',
                    value: _websiteData!.pages.length.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.image,
                    label: 'Images',
                    value: totalImages.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.link,
                    label: 'Links',
                    value: totalLinks.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(height: ResponsiveLayout.spacing8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPagesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Pages',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: ResponsiveLayout.spacing16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = ResponsiveLayout.getCrossAxisCount(context);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 1.2,
                crossAxisSpacing: ResponsiveLayout.spacing16,
                mainAxisSpacing: ResponsiveLayout.spacing16,
              ),
              itemCount: _websiteData!.pages.length,
              itemBuilder: (context, index) {
                final page = _websiteData!.pages[index];
                return _buildPageCard(page);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPageCard(PageData page) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToPage(page),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (page.content.images.isNotEmpty)
              Expanded(
                flex: 2,
                child: ResponsiveImage(
                  imageUrl: page.content.images.first.src,
                  altText: page.content.images.first.alt,
                  fit: BoxFit.cover,
                ),
              ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(ResponsiveLayout.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      page.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (page.description.isNotEmpty) ...[
                      SizedBox(height: ResponsiveLayout.spacing4),
                      Text(
                        page.description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPage(PageData page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageDetailScreen(page: page),
      ),
    );
  }
}