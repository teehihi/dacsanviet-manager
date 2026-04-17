import 'package:flutter/material.dart';
import '../../domain/domain.dart';

/// Example screen demonstrating API usage
class ExampleApiUsageScreen extends StatefulWidget {
  const ExampleApiUsageScreen({super.key});

  @override
  State<ExampleApiUsageScreen> createState() => _ExampleApiUsageScreenState();
}

class _ExampleApiUsageScreenState extends State<ExampleApiUsageScreen> {
  bool _isLoading = false;
  String _result = '';

  Future<void> _testLogin() async {
    setState(() {
      _isLoading = true;
      _result = 'Logging in...';
    });

    try {
      final response = await AuthService.login(
        email: 'admin@dacsanviet.com',
        password: 'admin123',
      );

      setState(() {
        if (response.success) {
          _result = 'Login successful!\n'
              'User: ${response.data!['user']['email']}\n'
              'Session ID: ${response.data!['sessionId']}';
        } else {
          _result = 'Login failed: ${response.message}';
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testGetProducts() async {
    setState(() {
      _isLoading = true;
      _result = 'Fetching products...';
    });

    try {
      final response = await ProductService.getProducts(
        page: 1,
        limit: 10,
      );

      setState(() {
        if (response.success) {
          final products = response.data!['products'] as List;
          final total = response.data!['total'];
          _result = 'Found $total products\n\n';
          
          for (var product in products.take(5)) {
            _result += '${product['name']}\n'
                'Price: ${product['price']} VND\n'
                'Stock: ${product['stock']}\n\n';
          }
        } else {
          _result = 'Failed to fetch products: ${response.message}';
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testGetOrders() async {
    setState(() {
      _isLoading = true;
      _result = 'Fetching orders...';
    });

    try {
      final response = await OrderService.getOrders(
        page: 1,
        limit: 10,
      );

      setState(() {
        if (response.success) {
          final orders = response.data!['orders'] as List;
          final total = response.data!['total'];
          _result = 'Found $total orders\n\n';
          
          for (var order in orders.take(5)) {
            _result += 'Order: ${order['order_number']}\n'
                'Status: ${order['status']}\n'
                'Total: ${order['total_amount']} VND\n\n';
          }
        } else {
          _result = 'Failed to fetch orders: ${response.message}';
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testGetRevenue() async {
    setState(() {
      _isLoading = true;
      _result = 'Fetching revenue stats...';
    });

    try {
      final response = await RevenueService.getRevenueStats();

      setState(() {
        if (response.success) {
          final data = response.data!;
          _result = 'Revenue Statistics\n\n'
              'Total Revenue: ${data['totalRevenue'] ?? 'N/A'} VND\n'
              'Total Orders: ${data['totalOrders'] ?? 'N/A'}\n'
              'Average Order: ${data['averageOrder'] ?? 'N/A'} VND\n';
        } else {
          _result = 'Failed to fetch revenue: ${response.message}';
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testGetUsers() async {
    setState(() {
      _isLoading = true;
      _result = 'Fetching users...';
    });

    try {
      final response = await UserService.getUsers(
        page: 1,
        limit: 10,
      );

      setState(() {
        if (response.success) {
          final users = response.data!['users'] as List;
          final total = response.data!['total'];
          _result = 'Found $total users\n\n';
          
          for (var user in users.take(5)) {
            _result += '${user['full_name'] ?? user['username']}\n'
                'Email: ${user['email']}\n'
                'Role: ${user['role']}\n\n';
          }
        } else {
          _result = 'Failed to fetch users: ${response.message}';
        }
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Usage Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Test API Integration',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Login button
            ElevatedButton(
              onPressed: _isLoading ? null : _testLogin,
              child: const Text('1. Test Login'),
            ),
            const SizedBox(height: 8),
            
            // Get products button
            ElevatedButton(
              onPressed: _isLoading ? null : _testGetProducts,
              child: const Text('2. Get Products'),
            ),
            const SizedBox(height: 8),
            
            // Get orders button
            ElevatedButton(
              onPressed: _isLoading ? null : _testGetOrders,
              child: const Text('3. Get Orders'),
            ),
            const SizedBox(height: 8),
            
            // Get revenue button
            ElevatedButton(
              onPressed: _isLoading ? null : _testGetRevenue,
              child: const Text('4. Get Revenue Stats'),
            ),
            const SizedBox(height: 8),
            
            // Get users button
            ElevatedButton(
              onPressed: _isLoading ? null : _testGetUsers,
              child: const Text('5. Get Users'),
            ),
            const SizedBox(height: 24),
            
            // Result display
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _result.isEmpty ? 'Click a button to test API' : _result,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
