import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servix/constents/constent.dart';
import 'package:share_plus/share_plus.dart';

class CommunityFeedScreen extends StatelessWidget {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('community_posts')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                color: ApplicationColor,
              ));

            final posts = snapshot.data!.docs;

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final postId = post.id;
                final data = post.data() as Map<String, dynamic>;

                final likes = (data['likes'] is int) ? data['likes'] : 0;
                final userLiked = data['user_liked'] ?? false;

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("user-files")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("uploads")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.docs.isNotEmpty) {
                                  String personalFileUrl = snapshot
                                      .data!.docs.first['personalFileUrl'];
                                  return CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20, // ✅ Adjust size
                                    backgroundImage: NetworkImage(
                                        personalFileUrl), // ✅ Fetch from Firestore
                                  );
                                }
                                return const CircleAvatar(
                                  backgroundColor: Colors.black26,
                                  radius: 15,
                                  child: Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Text(data['username'] ?? 'Anonymous',
                                style: GoogleFonts.castoro(
                                    fontWeight: FontWeight.bold, fontSize: 22)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text("${data['content'] ?? ''}",
                            style: GoogleFonts.castoro(
                                fontSize: 18, color: Colors.black54)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _updateLikes(postId, !userLiked);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: userLiked
                                            ? Colors.grey
                                            : ApplicationColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text('$likes'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                _showCommentsBottomSheet(context, postId);
                              },
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('community_posts')
                                    .doc(postId)
                                    .collection('comments')
                                    .snapshots(),
                                builder: (context, commentSnap) {
                                  if (!commentSnap.hasData)
                                    return const Text("0 comments");
                                  final commentCount =
                                      commentSnap.data!.docs.length;
                                  return Text('$commentCount comments');
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(), // optional separator
                        const SizedBox(height: 6),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () => _updateLikes(postId, true),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      size: 20,
                                      color: userLiked
                                          ? Colors.grey
                                          : ApplicationColor,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text("Love"),
                                  ],
                                ),
                              ),
                              // Comment Button
                              InkWell(
                                onTap: () {
                                  _showCommentsBottomSheet(context, postId);
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.mode_comment_outlined,
                                        color: Colors.grey, size: 20),
                                    SizedBox(width: 4),
                                    Text("Comment"),
                                  ],
                                ),
                              ),
                              // Share Button
                              GestureDetector(
                                onTap: () {
                                  _shareQuote(
                                      data['content'], data['username']);
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.reply,
                                        color: Colors.grey, size: 20),
                                    SizedBox(width: 4),
                                    Text("Share"),
                                  ],
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ApplicationColor,
        onPressed: () {
          _showPostUploadDialog(
              context); // Call method to show dialog or bottom sheet
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showPostUploadDialog(BuildContext context) {
    final TextEditingController _contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a Post'),
          content: TextField(
            controller: _contentController,
            decoration: const InputDecoration(hintText: "What's on your mind?"),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without posting
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _uploadPost(
                    context, _contentController); // Call upload post function
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _uploadPost(
      BuildContext context, TextEditingController _contentController) async {
    final user = FirebaseAuth.instance.currentUser;

    if (_contentController.text.trim().isEmpty || user == null) {
      return; // Don't upload if content is empty or user is not logged in
    }

    try {
      // Fetch user data from the 'users' collection using the user UID
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Assuming UID is used as the document ID
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      // Fetch the first name or set to 'Anonymous' if not available
      final firstName = userDoc.data()?['first_name'] ?? 'Anonymous';
      final lastName = userDoc.data()?['last_name'] ?? '';

      // Combine first name and last name
      final username = '$firstName $lastName'.trim();

      // Upload the post with the fetched username
      await FirebaseFirestore.instance.collection('community_posts').add({
        'userId': user.uid,
        'username': username, // Use the fetched username
        'content': _contentController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'likes': [], // Empty array for likes initially
      });

      _contentController.clear(); // Clear the input field
      Navigator.of(context).pop(); // Close the dialog

      // Show success message
      Fluttertoast.showToast(
        msg: 'Post uploaded successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );
    } catch (e) {
      // Handle error (if any)
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error uploading post: $e')));
      print('Error uploading post: $e');
    }
  }

  void _updateLikes(String postId, bool isLike) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // Ensure that user is logged in

    final ref =
        FirebaseFirestore.instance.collection('community_posts').doc(postId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) return;

      final currentData = snapshot.data() as Map<String, dynamic>;

      List<dynamic> usersLiked = currentData['users_liked'] ?? [];
      String userName = await _getUserNameFromFirestore(user.uid);

      int likes = (currentData['likes'] is int) ? currentData['likes'] : 0;
      bool userHasLiked =
          usersLiked.any((likedUser) => likedUser['id'] == user.uid);

      if (userHasLiked) {
        likes--;
        usersLiked.removeWhere((likedUser) => likedUser['id'] == user.uid);
      } else {
        likes++;
        usersLiked.add({
          'id': user.uid,
          'name': userName,
        });
      }

      // Update the post with the new like count and users who liked it
      transaction.update(ref, {
        'likes': likes,
        'users_liked': usersLiked,
      });
    });
  }

  Future<String> _getUserNameFromFirestore(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final firstName = userDoc.data()?['first_name'] ?? 'Anonymous';
        final lastName = userDoc.data()?['last_name'] ?? '';
        return '$firstName $lastName'.trim();
      }
      return 'Anonymous';
    } catch (e) {
      print('Error fetching user name: $e');
      return 'Anonymous';
    }
  }

  Widget _buildCommentsInBottomSheet(String postId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('community_posts')
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text("Loading comments...");

        final comments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: comments.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final commentData = comments[index].data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user-files")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("uploads")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        String personalFileUrl =
                            snapshot.data!.docs.first['personalFileUrl'];
                        return CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20, // ✅ Adjust size
                          backgroundImage: NetworkImage(
                              personalFileUrl), // ✅ Fetch from Firestore
                        );
                      }
                      return const CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 20,
                        child: Icon(
                          Icons.person,
                          size: 25,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${commentData['username'] ?? 'User'}",
                            style: GoogleFonts.castoro(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          ),
                          Text(
                            "${commentData['text'] ?? ''}",
                            style: GoogleFonts.castoro(
                                fontSize: 15, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCommentInput(String postId) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: _commentController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: "Add a comment",
                  labelStyle: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.31),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFAEAEAE), width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.send, color: ApplicationColor),
              onPressed: () => _addComment(postId),
            ),
          ],
        ),
      ),
    );
  }

  void _addComment(String postId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (_commentController.text.trim().isEmpty || user == null) return;

    final commentText = _commentController.text.trim();
    _commentController.clear();

    try {
      // Fetch user data from the 'users' collection using the user UID
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Assuming UID is used as the document ID
          .get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      // Fetch the first name or set to 'Anonymous' if not available
      final firstName = userDoc.data()?['first_name'] ?? 'Anonymous';
      final lastName = userDoc.data()?['last_name'] ?? '';

      // Combine first name and last name
      final username = '$firstName $lastName'.trim();

      // Add the comment with the fetched username
      await FirebaseFirestore.instance
          .collection('community_posts')
          .doc(postId)
          .collection('comments')
          .add({
        'text': commentText,
        'username': username, // Use the fetched username
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Optionally show a success message or do any other actions
      Fluttertoast.showToast(
        msg: 'Comment added successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  void _showCommentsBottomSheet(BuildContext context, String postId) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.white,
      isDismissible: true,
      enableDrag: true,
      elevation: 10,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      useSafeArea: true,
      useRootNavigator: true,
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Comments",
                    style: GoogleFonts.castoro(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: ApplicationColor,
                      decoration: TextDecoration.underline,
                    )),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildCommentsInBottomSheet(postId),
                  ),
                ),
                _buildCommentInput(
                    postId), // 🔻 This adds the comment input at the bottom
              ],
            ),
          ),
        );
      },
    );
  }

  void _shareQuote(String content, String username) {
    final quoteText = """
  🌟 Hey there! Check out this post from $username! 🌟
  📝 "$content"
  🔥 It's too good to miss! 📲 #Servix #CommunityVibes
  😎 Don't forget to join the conversation and share your thoughts! 💬
  """;
    Share.share(quoteText);
  }
}
