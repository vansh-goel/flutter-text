import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/chat.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _searchController;
  late List<String> _friendList;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadFriendList();
  }

  void _loadFriendList() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user_relationships')
        .doc(_auth.currentUser!.uid)
        .collection('friends')
        .get();
    setState(() {
      _friendList =
          snapshot.docs.map((doc) => doc.id).toList(); // Get friend IDs
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Home Page",
          style: TextStyle(color: Colors.indigo.shade400),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(
              Icons.logout,
            ),
            color: Colors.indigo.shade400,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo.shade400),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo.shade400),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo.shade400),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _addFriendByEmail(_searchController.text.trim());
                    _searchController.clear();
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Friends',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: _buildFriendList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendList() {
    return ListView.builder(
      itemCount: _friendList.length,
      itemBuilder: (context, index) {
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(_friendList[index])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final friendEmail = userData['email'];
            return ListTile(
              title: Text(
                friendEmail,
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                onPressed: () {
                  _removeFriend(_friendList[index]);
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      recieverUserEmail: friendEmail,
                      recieverUserId: _friendList[index],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _addFriendByEmail(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user found with email $email.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final friendId = snapshot.docs.first.id;
    if (!_friendList.contains(friendId)) {
      await FirebaseFirestore.instance
          .collection('user_relationships')
          .doc(_auth.currentUser!.uid)
          .collection('friends')
          .doc(friendId)
          .set({}); // Add friend to user's friend list
      _loadFriendList(); // Reload friend list
    }
  }

  void _removeFriend(String friendId) async {
    await FirebaseFirestore.instance
        .collection('user_relationships')
        .doc(_auth.currentUser!.uid)
        .collection('friends')
        .doc(friendId)
        .delete(); // Remove friend from user's friend list
    _loadFriendList(); // Reload friend list
  }

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }
}
