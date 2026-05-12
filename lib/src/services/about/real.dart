// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../common.dart';

@prod
@LazySingleton(as: AboutUsService)
class RealAboutUsService implements AboutUsService {
  // final _docRef = FirebaseFirestore.instance.collection('settings').doc('about_us');

  @override
  Future<AboutUs> get() async {
    return AboutUs(description: [], imageUrl: '', mission: '', vision: '');
    // final doc = await _docRef.get();
    // if (doc.exists && doc.data() != null) {
    //   return AboutUs.fromJson(doc.data()!);
    // }
    // return AboutUs(description: [], imageUrl: '', mission: '', vision: '');
  }

  @override
  Future<void> update(AboutUs aboutUs) async {
    // await _docRef.set(aboutUs.toJson(), SetOptions(merge: true));
  }
}
