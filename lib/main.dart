import 'package:flutter/material.dart';

void main() {
  runApp(const DegreeModernApp());
}

class DegreeModernApp extends StatelessWidget {
  const DegreeModernApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DegreePulse',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          elevation: 4,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        scaffoldBackgroundColor: Colors.grey[50], // Light background
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class Degree {
  final String name;
  final String code;
  final String duration;
  final String department;
  final String description;

  Degree({
    required this.name,
    required this.code,
    required this.duration,
    required this.department,
    required this.description,
  });
}

enum PageState { splash, list, details, add, edit }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageState _pageState = PageState.splash;
  final List<Degree> _degrees = [];
  Degree? _currentDegree;
  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    _degrees.addAll([
      Degree(
        name: 'Computer Science',
        code: 'CS101',
        duration: '4 Years',
        department: 'School of Computing',
        description:
            'A cutting-edge curriculum covering programming, algorithms, and data structures.',
      ),
      Degree(
        name: 'Software Engineering',
        code: 'SE102',
        duration: '4 Years',
        department: 'School of Engineering',
        description:
            'A program focusing on software development, design principles, and project management.',
      ),
      Degree(
        name: 'Business Studies',
        code: 'BS103',
        duration: '3 Years',
        department: 'School of Business',
        description:
            'A comprehensive program covering business fundamentals, management, and economics.',
      ),
    ]);
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _pageState = PageState.list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _getCurrentPage(),
    );
  }

  Widget _getCurrentPage() {
    switch (_pageState) {
      case PageState.splash:
        return _buildSplashScreen();
      case PageState.list:
        return _buildListScreen();
      case PageState.details:
        return _buildDetailsScreen();
      case PageState.add:
        return _buildFormScreen(isEditing: false);
      case PageState.edit:
        return _buildFormScreen(isEditing: true);
    }
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      key: const ValueKey('splash'),
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'DegreePulse',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              'Track. Manage. Succeed',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListScreen() {
    return Scaffold(
      key: const ValueKey('list'),
      appBar: AppBar(title: const Text('Degrees')),
      body:
          _degrees.isEmpty
              ? Center(
                child: Text(
                  'No degrees available.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _degrees.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final degree = _degrees[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDegree = degree;
                        _currentIndex = index;
                        _pageState = PageState.details;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(Icons.school, size: 40, color: Colors.indigo),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    degree.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${degree.code} • ${degree.duration}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    degree.department,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.indigo,
                              ),
                              onPressed: () {
                                setState(() {
                                  _currentDegree = degree;
                                  _currentIndex = index;
                                  _pageState = PageState.edit;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => _confirmDeletion(degree, index),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _pageState = PageState.add;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDeletion(Degree degree, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Degree'),
          content: Text('Are you sure you want to remove "${degree.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _degrees.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${degree.name}" has been removed')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailsScreen() {
    if (_currentDegree == null) return _buildListScreen();
    return Scaffold(
      key: const ValueKey('details'),
      appBar: AppBar(
        title: const Text('Degree Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _pageState = PageState.list;
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentDegree!.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Code: ${_currentDegree!.code}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Duration: ${_currentDegree!.duration}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Department: ${_currentDegree!.department}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentDegree!.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormScreen({required bool isEditing}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(
      text: isEditing ? _currentDegree?.name : '',
    );
    final codeController = TextEditingController(
      text: isEditing ? _currentDegree?.code : '',
    );
    final durationController = TextEditingController(
      text: isEditing ? _currentDegree?.duration : '',
    );
    final departmentController = TextEditingController(
      text: isEditing ? _currentDegree?.department : '',
    );
    final descriptionController = TextEditingController(
      text: isEditing ? _currentDegree?.description : '',
    );

    return Scaffold(
      key: ValueKey(isEditing ? 'editForm' : 'addForm'),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Degree' : 'Add Degree'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _pageState = PageState.list;
            });
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildInputField(
                controller: nameController,
                label: 'Degree Name',
                icon: Icons.school,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: codeController,
                label: 'Degree Code',
                icon: Icons.code,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: durationController,
                label: 'Duration',
                icon: Icons.timer,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: departmentController,
                label: 'Department',
                icon: Icons.business,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _pageState = PageState.list;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final newDegree = Degree(
                          name: nameController.text,
                          code: codeController.text,
                          duration: durationController.text,
                          department: departmentController.text,
                          description: descriptionController.text,
                        );
                        setState(() {
                          if (isEditing && _currentIndex != null) {
                            _degrees[_currentIndex!] = newDegree;
                          } else {
                            _degrees.add(newDegree);
                          }
                          _pageState = PageState.list;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing ? 'Degree updated' : 'Degree added',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(isEditing ? 'Update' : 'Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator:
          (value) =>
              value == null || value.trim().isEmpty
                  ? 'Please enter $label'
                  : null,
    );
  }
}
