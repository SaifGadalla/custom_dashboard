import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common.dart';
import '../firestore_service.dart';

class RealAboutUsService implements AboutUsService {
  final FirestoreService _fs;

  RealAboutUsService(this._fs);

  @override
  Future<AboutUs> get() async {
    final doc = await _fs.aboutUs.doc('main').get();
    if (doc.exists && doc.data() != null) {
      return doc.data()!;
    }
    return AboutUs(description: [], imageUrl: '', mission: '', vision: '');
  }

  @override
  Future<void> update(AboutUs aboutUs) async {
    await _fs.aboutUs.doc('main').set(aboutUs, SetOptions(merge: true));
  }
}
