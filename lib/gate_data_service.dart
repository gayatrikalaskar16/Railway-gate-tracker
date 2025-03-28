import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class GateDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllGates() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('gates').get();

      List<Map<String, dynamic>> allGates = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'location':
              LatLng(data['location'].latitude, data['location'].longitude),
        };
      }).toList();

      allGates.sort((a, b) => a['gate_id'].compareTo(b['gate_id']));
      developer.log('All gates: $allGates');

      return allGates;
    } catch (e) {
      return [];
    }
  }
}
