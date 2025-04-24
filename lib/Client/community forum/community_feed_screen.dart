import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:servix/constents/constent.dart';
import 'package:share_plus/share_plus.dart';
import '../../Theme/Theme_Provider.dart';

class CommunityFeedScreen extends StatefulWidget {
  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                color: ApplicationColor,
              ));
            }

            final posts = snapshot.data!.docs;

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final postId = post.id;
                final data = post.data() as Map<String, dynamic>;

                final currentUser = FirebaseAuth.instance.currentUser;
                final likes = (data['likes'] is int) ? data['likes'] : 0;
                final usersLiked =
                    List<Map<String, dynamic>>.from(data['users_liked'] ?? []);
                final userLiked = usersLiked
                    .any((likedUser) => likedUser['id'] == currentUser?.uid);

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.grey[500]
                      : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey[400],
                                  radius: 20,
                                  child: const Icon(Icons.person,
                                      size: 25, color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                Text(data['username'] ?? 'Anonymous',
                                    style: GoogleFonts.castoro(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)),
                              ],
                            ),
                            PopupMenuButton<String>(
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? const Color(0xFF333739)
                                  : Colors.white,
                              icon: Icon(
                                Icons.more_vert,
                                color: themeProvider.themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onSelected: (String value) async {
                                if (value == 'Delete') {
                                  bool confirm = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor:
                                          themeProvider.themeMode ==
                                                  ThemeMode.dark
                                              ? const Color(0xFF333739)
                                              : Colors.white,
                                      title: Row(
                                        children: [
                                          Icon(Icons.delete,
                                              color: themeProvider.themeMode ==
                                                      ThemeMode.dark
                                                  ? Colors.white
                                                  : ApplicationColor),
                                          const SizedBox(width: 10),
                                          Text('Delete Post'.tr(),
                                              style: GoogleFonts.castoro(
                                                  fontSize: 25)),
                                        ],
                                      ),
                                      content: Text(
                                          'Are you sure you want to delete this post?'
                                              .tr(),
                                          style: GoogleFonts.castoro(
                                              fontSize: 20)),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text('Cancel'.tr(),
                                              style: GoogleFonts.castoro(
                                                  fontSize: 20,
                                                color: themeProvider.themeMode ==
                                                    ThemeMode.dark
                                                    ? Colors.white
                                                    : Colors.black
                                              )),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text(
                                            'Delete'.tr(),
                                            style: GoogleFonts.castoro(
                                              color: themeProvider.themeMode ==
                                                      ThemeMode.dark
                                                  ? Colors.white
                                                  : ApplicationColor,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('community_posts')
                                          .doc(postId)
                                          .delete();

                                      Fluttertoast.showToast(
                                        msg: "Post deleted successfully!".tr(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        backgroundColor:
                                            ApplicationColorWithOpacity,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                      setState(() {});
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                        msg: "Failed to delete post: $e".tr(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.TOP,
                                        backgroundColor:
                                            ApplicationColorWithOpacity,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  }
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem<String>(
                                    value: 'Delete',
                                    child: Text(
                                      'Delete Post'.tr(),
                                      style: GoogleFonts.castoro(
                                        color: themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.white
                                            : ApplicationColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text("${data['content'] ?? ''}",
                            style: GoogleFonts.castoro(
                                fontSize: 18, color: Colors.black54)),
                        if (data['imageUrls'] != null &&
                            (data['imageUrls'] as List).isNotEmpty)
                          SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: (data['imageUrls'] as List)
                                      .length, // Ensure this is a list
                                  itemBuilder: (context, imgIndex) {
                                    String imageUrl =
                                        (data['imageUrls'] as List)[imgIndex];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(imageUrl,
                                            fit: BoxFit.cover),
                                      ),
                                    );
                                  })),
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
                                        color: ApplicationColor,
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
                                  if (!commentSnap.hasData) {
                                    return const Text("0 comments");
                                  }
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
                                onTap: () {
                                  _updateLikes(
                                      postId, !userLiked); // Toggle like
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      userLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      size: 20,
                                      color: userLiked
                                          ? ApplicationColor
                                          : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Love".tr(),
                                      style: GoogleFonts.castoro(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),

                              // Comment Button
                              InkWell(
                                onTap: () {
                                  _showCommentsBottomSheet(context, postId);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.mode_comment_outlined,
                                        color: themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.black54
                                            : Colors.grey,
                                        size: 20),
                                    const SizedBox(width: 4),
                                    Text("Comment".tr(),
                                        style:
                                            GoogleFonts.castoro(fontSize: 16)),
                                  ],
                                ),
                              ),
                              // Share Button
                              GestureDetector(
                                onTap: () {
                                  _shareQuote(
                                      data['content'], data['username']);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.reply,
                                        color: themeProvider.themeMode ==
                                                ThemeMode.dark
                                            ? Colors.black54
                                            : Colors.grey,
                                        size: 20),
                                    const SizedBox(width: 4),
                                    Text("Share".tr(),
                                        style:
                                            GoogleFonts.castoro(fontSize: 16)),
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
          _showPostUploadDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  List<File> _selectedImages = [];

  void _showPostUploadDialog(BuildContext context) {
    final TextEditingController _contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title:
                Text('Create a Post'.tr(), style: GoogleFonts.castoro(fontSize: 30)),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _contentController,
                    keyboardType: TextInputType.text,
                    autocorrect: true,
                    enableSuggestions: true,
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                    ),
                    style: GoogleFonts.castoro(fontSize: 20),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedImages
                        .map((file) => Image.file(file,
                            height: 100, width: 100, fit: BoxFit.cover))
                        .toList(),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: ApplicationColor,
                    ),
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFiles = await picker
                          .pickMultiImage(); // This allows multi-pick
                      if (pickedFiles.isNotEmpty) {
                        setState(() {
                          _selectedImages = pickedFiles
                              .map((pickedFile) => File(pickedFile.path))
                              .toList();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.image,
                      color: ApplicationColor,
                      size: 20,
                    ),
                    label: Text(
                      "Add Image".tr(),
                      style: GoogleFonts.castoro(
                        color: ApplicationColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _contentController.clear();
                  _selectedImages.clear(); // Clear selected images
                },
                child: Text('Cancel'.tr(),
                    style:
                        GoogleFonts.castoro(color: Colors.black, fontSize: 23)),
              ),
              TextButton(
                onPressed: () {
                  _uploadPost(context, _contentController);
                },
                child: Text('Post'.tr(),
                    style: GoogleFonts.castoro(
                        fontSize: 23, color: ApplicationColor)),
              ),
            ],
          );
        });
      },
    );
  }

  Future<String?> uploadToCloudinary(File imageFile) async {
    String cloudinaryUrl =
        "https://api.cloudinary.com/v1_1/dstg1nqdx/image/upload";
    String uploadPreset = "Servix";

    var request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
    request.fields["upload_preset"] = uploadPreset;
    request.files
        .add(await http.MultipartFile.fromPath("file", imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      return jsonResponse["secure_url"];
    } else {
      print(
          "Cloudinary upload failed with status code: ${response.statusCode}");
      return null;
    }
  }

  Future<void> _uploadPost(
      BuildContext context, TextEditingController _contentController) async {
    final user = FirebaseAuth.instance.currentUser;

    // Check if content is empty
    if (_contentController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter content before posting.'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );
      return;
    }

    if (user == null) return;

    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userId = user.uid;

      // Try to get the document from 'users' collection
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      String role = 'user';
      if (!userDoc.exists) {
        // If not found, try 'technicians' collection
        userDoc = await firestore.collection('technician').doc(userId).get();
        if (!userDoc.exists) throw Exception('User or Technician not found');
        role = 'technician';
      }

      final data = userDoc.data() as Map<String, dynamic>;
      final firstName = data['first_name'] ?? 'Anonymous';
      final lastName = data['last_name'] ?? '';
      final username = '$firstName $lastName'.trim();

      List<String> imageUrls = [];
      for (var imageFile in _selectedImages) {
        final url = await uploadToCloudinary(imageFile);
        if (url != null) {
          imageUrls.add(url);
        }
      }

      await firestore.collection('community_posts').add({
        'userId': userId,
        'username': username,
        'role': role,
        'content': _contentController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'imageUrls': imageUrls,
        'likes': [],
      });

      _contentController.clear();
      _selectedImages.clear();
      Navigator.of(context).pop();

      Fluttertoast.showToast(
        msg: 'Post uploaded successfully!'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading post: $e'.tr())),
      );
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
      // Try fetching from 'users' collection
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final firstName = userDoc.data()?['first_name'] ?? 'Anonymous';
        final lastName = userDoc.data()?['last_name'] ?? '';
        return '$firstName $lastName'.trim();
      }

      // If not found in 'users', try 'technicians'
      final techDoc = await FirebaseFirestore.instance
          .collection('technician')
          .doc(uid)
          .get();
      if (techDoc.exists) {
        final firstName = techDoc.data()?['first_name'] ?? 'Anonymous';
        final lastName = techDoc.data()?['last_name'] ?? '';
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
        if (!snapshot.hasData) return const Text("Loading comments...").tr();

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            controller: _commentController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: "Add a comment".tr(),
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
        msg: 'Comment added successfully!'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ApplicationColorWithOpacity,
        textColor: Colors.white,
      );
    } catch (e) {
      print('Error adding comment: $e'.tr());
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
                Text("Comments".tr(),
                    style: GoogleFonts.castoro(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: ApplicationColor,
                      decoration: TextDecoration.underline,
                    )),
                const SizedBox(height: 10),
                _buildCommentInput(postId),
                const SizedBox(height: 10),
                _buildCommentsInBottomSheet(postId),
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
  😎 Don't forget to join the conversation and share your thoughts! 💬
  """;
    Share.share(quoteText);
  }
}
