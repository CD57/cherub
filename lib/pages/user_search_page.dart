import 'package:cherub/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';
import '../widgets/user_search_result_widget.dart';

late Future<QuerySnapshot>? searchResultsFuture;

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({Key? key}) : super(key: key);
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearchPage> {
  final CollectionReference<Map<String, dynamic>> usersRef =
      FirebaseFirestore.instance.collection('Users');
  TextEditingController searchController = TextEditingController();
  late AuthProvider _auth;
  bool searching = false;

  // Build depends on available search results
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("user_search_page.dart - build()");
    }
    _auth = Provider.of<AuthProvider>(context);
    String currentUserId = _auth.user.userId;
    return Scaffold(
      appBar: buildSearchField(),
      body: searching ? buildSearchResults(currentUserId) : buildNoContent(),
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
      searchResultsFuture = users;
      searching = true;
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

// Display image and text while no users displayed
Center buildNoContent() {
  if (kDebugMode) {
    print("user_search_page.dart - buildNoContent()");
  }
  return Center(
    child: ListView(
      shrinkWrap: true,
      children: const <Widget>[
        Text(
          "Find Users",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            fontSize: 60.0,
          ),
        ),
      ],
    ),
  );
}

// Display Users using UserSearchResult class
buildSearchResults(String _currentUserId) {
  if (kDebugMode) {
    print("user_search_page.dart - buildSearchResults()");
  }
  late DatabaseService _dbService;
  _dbService = GetIt.instance.get<DatabaseService>();
  return FutureBuilder(
    future: searchResultsFuture,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const CircularProgressIndicator();
      }
      List<UserSearchResultsWidget> searchResults = [];
      for (var doc in (snapshot.data! as QuerySnapshot).docs) {
        UserModel aUser = UserModel.fromDocument(doc);
        UserSearchResultsWidget searchResult = UserSearchResultsWidget(aUser, _dbService, _currentUserId);
        searchResults.add(searchResult);
      }
      return ListView(
        children: searchResults,
      );
    },
  );
}
