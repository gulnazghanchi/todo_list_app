import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../services/payment_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Post> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _posts = jsonData.map((json) => Post.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load posts';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Posts',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Oops! Something went wrong',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          _fetchPosts();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchPosts,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        PaymentService.makePayment(
                                          context,
                                          amount: 9.99, // Example amount
                                        );
                                      },
                                      icon: Icon(
                                        Icons.payment,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        'Make Payment',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.secondary,
                                        padding: EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                post.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                post.body,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'User ${post.userId}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.comment_outlined,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Post ${post.id}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
