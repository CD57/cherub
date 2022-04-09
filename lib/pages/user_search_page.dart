import 'package:cherub/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../widgets/user_search_result_widget.dart';

late Future<QuerySnapshot>? _searchResultsFuture;
late Future<QuerySnapshot>? _friendResultsFuture;
late List<String> friendRequestsStringList = [];
//late AuthProvider _auth;
late String _uid;
DatabaseService _dbService = GetIt.instance.get<DatabaseService>();

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({Key? key}) : super(key: key);
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearchPage> {
  final CollectionReference<Map<String, dynamic>> usersRef =
      FirebaseFirestore.instance.collection('Users');
  TextEditingController searchController = TextEditingController();
  bool searching = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AuthProvider _auth;
    _auth = Provider.of<AuthProvider>(context);
    _uid = _auth.user.userId;
    getFriendRequests();
    handleFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body: searching ? buildSearchResults() : buildRequestResults(),
    );
  }

  // App bar containing search field
  AppBar buildSearchField() {
    return AppBar(
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search Usernames",
          hintStyle: const TextStyle(color: Colors.white),
          filled: true,
          prefixIcon:
              const Icon(Icons.account_box, size: 28.0, color: Colors.white),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: clearSearch,
          ),
        ),
        onFieldSubmitted: handleSearch,
      ),
    );
  }

  // Retrieves requested display name from user database
  handleSearch(String query) {
    if (kDebugMode) {
      print("user_search_page.dart - handleSearch()");
    }
    Future<QuerySnapshot> users =
        usersRef.where("username", isEqualTo: query).get();
    setState(() {
      _searchResultsFuture = users;
      searching = true;
    });
  }

  // Gets pending friend requests
  getFriendRequests() async {
    if (kDebugMode) {
      print("user_search_page.dart - getFriendRequests()");
    }
    List<String> friendRequests = await _dbService.getFriendRequests(_uid);
    if (kDebugMode) {
      print("user_search_page.dart - getFriendRequests() - " +
          friendRequests.toString());
    }
    setState(() {
      friendRequestsStringList = friendRequests;
      _uid = _uid;
    });
  }

  // Gets pending friend requests
  handleFriendRequests() {
    if (kDebugMode) {
      print("user_search_page.dart - handleFriendRequests()");
    }
    var sRef = FirebaseFirestore.instance
        .collection('Users')
        .where("models", arrayContains: friendRequestsStringList)
        .get();
    Future<QuerySnapshot> users = sRef;
    setState(() {
      _friendResultsFuture = users;
    });
  }

  // Clears search results
  clearSearch() {
    if (kDebugMode) {
      print("user_search_page.dart - clearSearch()");
    }
    searchController.clear();
    setState(() {
      searching = false;
    });
  }
}

// Display Users using UserSearchResultsWidget class
buildSearchResults() {
  if (kDebugMode) {
    print("user_search_page.dart - buildSearchResults()");
  }
  return FutureBuilder(
    future: _searchResultsFuture,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const CircularProgressIndicator();
      }
      List<UserSearchResultsWidget> searchResults = [];
      for (var doc in (snapshot.data! as QuerySnapshot).docs) {
        UserModel aUser = UserModel.fromDocument(doc);
        UserSearchResultsWidget searchResult =
            UserSearchResultsWidget(aUser, _dbService, _uid);
        searchResults.add(searchResult);
      }
      return ListView(
        children: searchResults,
      );
    },
  );
}

// Display Users using FriendRequestListWidget class
buildRequestResults() {
  if (kDebugMode) {
    print("user_search_page.dart - buildRequestsResults()");
  }
  return FutureBuilder(
    future: _friendResultsFuture,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const CircularProgressIndicator();
      }
      List<FriendRequestListWidget> friendRequestResults = [];
      for (var doc in (snapshot.data! as QuerySnapshot).docs) {
        UserModel aUser = UserModel.fromDocument(doc);
        FriendRequestListWidget aFriendRequest =
            FriendRequestListWidget(aUser, _dbService, _uid);
        friendRequestResults.add(aFriendRequest);
      }
      if (kDebugMode) {
        print("buildRequestsResults() - Length: " +
            friendRequestResults.length.toString());
      }
      return ListView(
        children: friendRequestResults,
      );
    },
  );
}

// // Display image and text while no users displayed
// buildNoContent() {
//   if (kDebugMode) {
//     print("user_search_page.dart - buildNoContent()");
//   }
//   return FutureBuilder(
//     builder: (context, snapshot) {
//       if (friendRequestsList.isEmpty) {
//         return const Text("Add a Friend");
//       }
//       return ListView(
//         children: friendRequestsList,
//       );
//     },
//   );
// }
