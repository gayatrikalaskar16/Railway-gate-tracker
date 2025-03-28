import 'package:cloud_firestore/cloud_firestore.dart';

class GateDataUploader {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadGateData(List<Map<String, dynamic>> gateData) async {
    try {
      WriteBatch batch = _firestore.batch();

      for (var gate in gateData) {
        DocumentReference docRef =
            _firestore.collection('gates').doc(gate['gate_id'].toString());

        Map<String, dynamic> gateDataToUpload = {
          'gate_name': gate['gate_name'],
          'gate_id': gate['gate_id'],
          'location': GeoPoint(
              gate['location']['latitude'], gate['location']['longitude']),
          'timing': gate['timing'],
        };

        batch.set(docRef, gateDataToUpload);
      }

      await batch.commit();
    } catch (e) {}
  }
}
