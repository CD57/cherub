//Displays and holds user search results
import 'package:cherub/models/date_details_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DateDetailsWidget extends StatelessWidget {
  final DateDetailsModel aDate;
  final DatabaseService _dbService;
  final String _currentUserId;
  const DateDetailsWidget(this.aDate, this._dbService, this._currentUserId,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("date_details_widget.dart - build()");
    }
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () =>
                dateOptions(context, _dbService, _currentUserId, aDate.hostID),
            child: ListTile(
              title: Text(
                aDate.dateTime.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                aDate.datePlan,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }

  void dateOptions(BuildContext context, DatabaseService _dbService,
      String _uid, String _dateId) {
    if (kDebugMode) {
      print("date_details_widget.dart - contactOptions");
    }
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Date Options'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (kDebugMode) {
                  print("dateOptions - Delete Date");
                }
                Navigator.pop(context);
              },
              child: const Text('Delete Date'),
            ),
          ],
        );
      },
    );
  }
}
