import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPost extends StatefulWidget {
  const UserPost({super.key});

  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      String? username = await getUsernameForCurrentUser();
      setState(() {
        _username = username;
      });
    } catch (e) {
      print('Error loading username: $e');
      setState(() {
        _username = null;
      });
    }
  }

  Future<String?> getUsernameForCurrentUser() async {
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1)
        .get();
    if (querySnapshot.size > 0) {
      return querySnapshot.docs.first.get('username') as String?;
    }
    return null;
  }

  String getElapsedTime(Timestamp timestamp) {
    DateTime postTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(postTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final headline = post['headline'] as String?;
              final writer = post['writer'] as String?;
              final content = post['content'] as String?;
              final timestamp = post['timestamp'] as Timestamp?;

              String elapsedTime = '';
              if (timestamp != null) {
                elapsedTime = getElapsedTime(timestamp);
              }

              return GestureDetector(
                onTap: () {
                  // Handle onTap to show expanded post content
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpandedPostView(
                        headline: headline,
                        writer: writer,
                        content: content,
                        elapsedTime: elapsedTime,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Posted by ${writer ?? 'Unknown'} - $elapsedTime',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          headline ?? '',
                          style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostDialog(context);
        },
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.post_add, color: Colors.white),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    String headline = '';
    String content = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.black,
          content: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        'Create a New Post',
                        style: GoogleFonts.manrope(fontSize: 20,
                          fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Headline',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        headline = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        content = value;
                      },
                      maxLines: null,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 10),

                        Container(
                          height: 37,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              _createNewPost(headline, content);
                              Navigator.pop(context);
                            },
                            child: const Text('Post',
                              style: TextStyle(color: Colors.black),),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierLabel: 'Dismiss',
    );
  }



  void _createNewPost(String headline, String content) {
    FirebaseFirestore.instance.collection('posts').add({
      'headline': headline,
      'writer': _username ?? 'Unknown',
      'content': content,
      'timestamp': Timestamp.now(),
    });
  }
}

class ExpandedPostView extends StatelessWidget {
  final String? headline;
  final String? writer;
  final String? content;
  final String? elapsedTime;

  const ExpandedPostView({
    super.key,
    this.headline,
    this.writer,
    this.content,
    this.elapsedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Post Details', style: GoogleFonts.manrope(color: Colors.white,),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Posted by ${writer ?? 'Unknown'} - $elapsedTime',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              headline ?? '',
              style:  GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            Text(
              content ?? '',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
