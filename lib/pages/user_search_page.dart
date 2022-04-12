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
late List<FriendRequestListWidget> friendRequestResults = [];
late List<UserModel> friendRequestsUsersList = [];
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
  final CollectionReference<Map<String, dynamic>> friendsRef =
      FirebaseFirestore.instance.collection('Friends');
  TextEditingController searchController = TextEditingController();
  bool loadingBool = true;
  bool searchingBool = false;
  bool loadRequestsBool = false;

  @override
  void initState() {
    if (kDebugMode) {
      print("user_search_page.dart - initState()");
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (kDebugMode) {
      print("user_search_page.dart - didChangeDependencies()");
    }
    super.didChangeDependencies();
    AuthProvider _auth;
    _auth = Provider.of<AuthProvider>(context);
    setState(() {
      if (kDebugMode) {
        print(
            "user_search_page.dart - didChangeDependencies() - setState:  _uid = _auth.user.userId, friendRequestResults = []");
      }
      _uid = _auth.user.userId;
      friendRequestResults = [];
    });
    handleFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body: searchingBool
          ? buildSearchResults()
          : loadRequestsBool
              ? buildRequestResults()
              : loadingBool
                  ? buildLoadingContent()
                  : buildNoContent(),
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
          prefixIcon: IconButton(
            icon: const Icon(
              Icons.account_box,
              color: Colors.white,
            ),
            onPressed: loadRequests,
          ),
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
      print("user_search_page.dart - handleSearch() - Search: $query");
    }
    Future<QuerySnapshot> users =
        usersRef.where("username", isEqualTo: query).get();
    if (kDebugMode) {
      print("Users@@@@@@:" + users.toString());
    }
    setState(() {
      if (kDebugMode) {
        print(
            "user_search_page.dart - handleSearch() - setState: _searchResultsFuture = users, searchingBool = true");
      }
      _searchResultsFuture = users;
      searchingBool = true;
    });
  }

  // Gets pending friend requests
  handleFriendRequests() async {
    if (kDebugMode) {
      print("user_search_page.dart - handleFriendRequests()");
    }
    List<String> friendRequests = await _dbService.getFriendRequests(_uid);
    List<UserModel> tempFriendRequestsUsersList = [];
    Future<QuerySnapshot>? users = _dbService.getUsersFromList(friendRequests);

    if (kDebugMode) {
      print("Users@@@@@@:" + users.toString());
    }
    for (String friend in friendRequests) {
      UserModel aUser;

      await _dbService.getUserByID(friend).then(
        (_snapshot) {
          if (_snapshot.data() != null) {
            Map<String, dynamic> _userData =
                _snapshot.data()! as Map<String, dynamic>;
            aUser = UserModel.fromJSON(
              {
                "userId": friend,
                "username": _userData["username"],
                "name": _userData["name"],
                "number": _userData["number"],
                "email": _userData["email"],
                "lastActive": _userData["lastActive"],
                "imageURL": _userData["imageURL"],
              },
            );
            if (kDebugMode) {
              print("User: " + aUser.toMap().toString());
            }
            tempFriendRequestsUsersList.add(aUser);
          } else {
            if (kDebugMode) {
              print("auth_provider.dart - AuthProvider() - No User Data Found");
            }
          }
        },
      );
    }
    for (UserModel aUser in tempFriendRequestsUsersList) {
      FriendRequestListWidget aFriendRequest =
          FriendRequestListWidget(aUser, _dbService, _uid);
      if (!friendRequestResults.contains(aFriendRequest)) {
        friendRequestResults.add(aFriendRequest);
      } else {
        if (kDebugMode) {
          print("buildRequestResults - Friend Already Loaded");
        }
      }
    }
    setState(() {
      if (kDebugMode) {
        print(
            "handleFriendRequests() - setState: friendRequestResults = friendRequestResults, loadingBool = false");
      }
      friendRequestResults = friendRequestResults;
      loadingBool = false;
    });
  }

  // Clears search results
  clearSearch() {
    if (kDebugMode) {
      print("user_search_page.dart - clearSearch()");
    }
    searchController.clear();
    setState(() {
      if (kDebugMode) {
        print(
            "clearSearch() - setState: searchingBool = false, loadRequestsBool = false");
      }
      searchingBool = false;
      loadRequestsBool = false;
    });
  }

  // Display Users using FriendRequestListWidget class
  Widget buildRequestResults() {
    if (kDebugMode) {
      print("user_search_page.dart - buildRequestsResults()");
    }
    return ListView(
      children: friendRequestResults,
    );
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
          return const Center(child: CircularProgressIndicator());
        }
        List<UserSearchResultsWidget> searchResultsList = [];
        for (var doc in (snapshot.data! as QuerySnapshot).docs) {
          UserModel aUser = UserModel.fromDocument(doc);
          UserSearchResultsWidget aSearchResult =
              UserSearchResultsWidget(aUser, _dbService, _uid);
          searchResultsList.add(aSearchResult);
        }
        if (kDebugMode) {
          print("user_search_page.dart - buildSearchResults() - Length: " +
              searchResultsList.length.toString());
        }
        return ListView(
          children: searchResultsList,
        );
      },
    );
  }

// Display image and text while no users displayed
  Center buildNoContent() {
    if (kDebugMode) {
      print("user_search_page.dart - buildNoContent()");
    }
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text(
            "Find Users",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green.shade900,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              fontSize: 60.0,
            ),
          ),
          TextButton(
              onPressed: loadRequests,
              child: const Text("View Friend Requests"))
        ],
      ),
    );
  }

  Center buildLoadingContent() {
    if (kDebugMode) {
      print("user_search_page.dart - buildNoContent()");
    }
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Text(
            "Loading...",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green.shade900,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              fontSize: 60.0,
            ),
          ),
          const CircularProgressIndicator()
        ],
      ),
    );
  }

  void loadRequests() {
    setState(() {
      if (kDebugMode) {
        print("loadRequests() - setState: loadRequestsBool = true");
      }
      loadRequestsBool = true;
    });
  }
}
