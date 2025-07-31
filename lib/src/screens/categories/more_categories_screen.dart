import 'package:flutter/material.dart';

class MoreCategoriesScreen extends StatefulWidget {
  const MoreCategoriesScreen({super.key});

  @override
  State<MoreCategoriesScreen> createState() => _MoreCategoriesScreenState();
}

class _MoreCategoriesScreenState extends State<MoreCategoriesScreen> {
  List<String> onlineCategories = [];
  bool isLoading = true;
  String? error;

  // Example: Replace with your real API call
  Future<void> fetchCategories() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      // TODO: Replace with real API call
      onlineCategories = [
        'Music',
        'Movies',
        'Science',
        'History',
        'Sports',
        'Technology',
      ];
    } catch (e) {
      error = 'Failed to load categories';
    }
    setState(() {
      isLoading = false;
    });
  }

  // Example: Replace with your real API call
  Future<void> uploadCategory(String name) async {
    // TODO: Implement upload logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Uploaded "$name" (not really, just a stub)')),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('More Categories')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Center(child: Text(error!))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Online Categories', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: onlineCategories.length,
                      itemBuilder: (context, index) {
                        final category = onlineCategories[index];
                        return Card(
                          child: ListTile(
                            title: Text(category),
                            trailing: ElevatedButton(
                              onPressed: () {
                                // TODO: Handle category selection
                                Navigator.pop(context, category);
                              },
                              child: const Text('Choose'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Text('Upload a Category', style: theme.textTheme.titleLarge),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Category Name',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final name = _controller.text.trim();
                          if (name.isNotEmpty) {
                            uploadCategory(name);
                            _controller.clear();
                          }
                        },
                        child: const Text('Upload'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
