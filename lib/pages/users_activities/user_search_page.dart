import 'package:cherub/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../widgets/user_search_result_widget.dart';

final DatabaseService _dbService = GetIt.instance.get<DatabaseService>();
late Future<QuerySnapshot>? _searchResultsFuture;
late List<FriendRequestListWidget> friendRequestWidgetList = [];
late List<FriendListWidget> friendsWidgetList = [];
late String _uid;

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({Key? key}) : super(key: key);
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearchPage> {
  final CollectionReference<Map<String, dynamic>> usersRef =
      FirebaseFirestore.instance.collection('Users');
  TextEditingController searchController = TextEditingController();
  bool loadingBool = true;
  bool searchingBool = false;
  bool loadRequestsBool = false;
 
  @override
  void didChangeDependencies() {
    if (kDebugMode) {
      print("user_search_page.dart - didChangeDependencies()");
    }
    super.didChangeDependencies();
    AuthProvider _auth = Provider.of<AuthProvider>(context);
    setState(() {
      _uid = _auth.user.userId;
    });
    getFriendRequests();
    getUsersFriends();
  }

  // Gets pending friend requests
  getFriendRequests() async {
    if (kDebugMode) {
      print("user_search_page.dart - handleFriendRequests()");
    }
    // Get list of User ID's that sent a friend request and empty current friendRequestWidgetList
    List<String> friendRequests = await _dbService.getFriendRequests(_uid);
    List<UserModel> tempFriendRequestsUsersList = [];
    friendRequestWidgetList = [];

    // For each friend request, get user using userId and add to temp list
    for (String friend in friendRequests) {
      await _dbService.getUserByID(friend).then(
        (_snapshot) {
          if (_snapshot.data() != null) {
            // DocumentSnapshot _userData = _snapshot.data()! as DocumentSnapshot;
            // UserModel aUser = UserModel.fromDocument(_userData);
            Map<String, dynamic> _userData =
                _snapshot.data()! as Map<String, dynamic>;
            UserModel aUser = UserModel.fromJSON(
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
            tempFriendRequestsUsersList.add(aUser);
          }
        },
      );
    }
    // For each user in tempList, create related widget to display data and add to list of widgets
    for (UserModel user in tempFriendRequestsUsersList) {
      FriendRequestListWidget aFriendRequest =
          FriendRequestListWidget(user, _dbService, _uid);
      if (!friendRequestWidgetList.contains(aFriendRequest)) {
        friendRequestWidgetList.add(aFriendRequest);
      }
    }
    // Update main widget list
    setState(() {
      friendRequestWidgetList = friendRequestWidgetList;
    });
  }

  // Get pending friend requests
  getUsersFriends() async {
    if (kDebugMode) {
      print("user_search_page.dart - getUsersFriends()");
    }
    // Get list of current user's friend Uids and empty current friendsWidgetList
    List<String> usersFriendUids = await _dbService.getFriendsID(_uid);
    List<UserModel> tempFriendsList = [];
    friendsWidgetList = [];

    // For each friend, get user using Uid and add to temp list
    for (String friend in usersFriendUids) {
      await _dbService.getUserByID(friend).then(
        (_snapshot) {
          if (_snapshot.data() != null) {
            // DocumentSnapshot _userFriendData = _snapshot.data()! as DocumentSnapshot;
            // UserModel aUser = UserModel.fromDocument(_userFriendData);
            Map<String, dynamic> _userData =
                _snapshot.data()! as Map<String, dynamic>;
            UserModel aUser = UserModel.fromJSON(
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
            tempFriendsList.add(aUser);
          }
        },
      );
    }
    // For each user in tempList, create related widget to display data and add to list of widgets
    for (UserModel aUser in tempFriendsList) {
      FriendListWidget aFriendRequest =
          FriendListWidget(aUser, _uid, _dbService);
      if (!friendsWidgetList.contains(aFriendRequest)) {
        friendsWidgetList.add(aFriendRequest);
      }
    }
    // Update main widget list and set loadingBool to false to indicate data has been retrieved
    setState(() {
      friendsWidgetList = friendsWidgetList;
      loadingBool = false;
    });
  }

  // Retrieves requested display name from database using usersRef
  getSearchResults(String query) {
    if (kDebugMode) {
      print("user_search_page.dart - getSearchResults() - Search: $query");
    }
    Future<QuerySnapshot> users =
        usersRef.where("username", isEqualTo: query).get();

    // Update _searchResultsFuture to be used in FutureBuilder, and set searchingBool to true to indicate user is using search function
    setState(() {
      _searchResultsFuture = users;
      searchingBool = true;
    });
  }

  // Build body based on active bools, such as searching and viewing friend requests
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
                  : buildFriendList(),
    );
  }

  // App bar containing search field
  AppBar buildSearchField() {
    return AppBar(
      title: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search by Username",
          hintStyle: const TextStyle(color: Colors.white),
          filled: true,
          prefixIcon: IconButton(
            icon: const Icon(
              Icons.account_box,
              color: Colors.white,
            ),
            onPressed: loadRequests, // Load friend request
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: clearPage, // Clear active bools
          ),
        ),
        onFieldSubmitted: getSearchResults, // Get search results based on input
      ),
    );
  }

  // Display Users Friend Requests using FriendRequestListWidget class if found
  Widget buildRequestResults() {
    if (kDebugMode) {
      print("user_search_page.dart - buildRequestsResults()");
    }
    if (friendRequestWidgetList.isEmpty) {
      return Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              "No Pending Requests",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green.shade900,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 40.0,
              ),
            ),
            TextButton(
                onPressed: clearPage,
                child: Text(
                  "Return to Contacts Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ))
          ],
        ),
      );
    } else {
      return ListView(
        children: friendRequestWidgetList,
      );
    }
  }

  // Display Users using UserSearchResultsWidget class.
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
        return ListView(
          children: searchResultsList,
        );
      },
    );
  }

  // Display image and text while no users displayed
  buildFriendList() {
    if (kDebugMode) {
      print("user_search_page.dart - buildFriendList()");
    }
    if (friendsWidgetList.isNotEmpty) {
      return Center(
        child: ListView(
          children: friendsWidgetList,
        ),
      );
    } else {
      return Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
              "Add Friends using their Username",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green.shade900,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 40.0,
              ),
            ),
            TextButton(
                onPressed: loadRequests,
                child: Text(
                  "Check Friend Requests",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ))
          ],
        ),
      );
    }
  }

  // Displays content while loadingBool is true
  buildLoadingContent() {
    if (kDebugMode) {
      print("user_search_page.dart - buildLoadingContent()");
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

  // Clears search results
  clearPage() {
    if (kDebugMode) {
      print("user_search_page.dart - clearSearch()");
    }
    searchController.clear();
    setState(() {
      searchingBool = false;
      loadRequestsBool = false;
    });
  }

  // Sets loadRequestsBool to true, changing the scaffold body
  loadRequests() {
    if (kDebugMode) {
      print("user_search_page.dart - loadRequests()");
    }
    setState(() {
      loadRequestsBool = true;
    });
  }
}
