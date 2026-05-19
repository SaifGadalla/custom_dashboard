import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_dashboard/common.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Service> get appServices => _firestore
      .collection('services')
      .withConverter<Service>(
        fromFirestore: (snapshot, options) =>
            Service.fromJson(snapshot.data()!),
        toFirestore: (data, options) => data.toJson(),
      );

  CollectionReference<Article> get articles => _firestore
      .collection('articles')
      .withConverter<Article>(
        fromFirestore: (snapshot, options) =>
            Article.fromJson(snapshot.data()!),
        toFirestore: (data, options) => data.toJson(),
      );

  CollectionReference<AppFile> get mediaLibraryImages => FirebaseFirestore
      .instance
      .collection('media')
      .withConverter<AppFile>(
        fromFirestore: (snapshot, options) =>
            AppFile.fromJson(snapshot.data()!),
        toFirestore: (data, options) => data.toJson(),
      );

  CollectionReference<Category> get categories => _firestore
      .collection('categories')
      .withConverter<Category>(
        fromFirestore: (snapshot, options) =>
            Category.fromJson(snapshot.data()!),
        toFirestore: (data, options) => data.toJson(),
      );

  CollectionReference<AppUser> get appUsers => _firestore
      .collection('users')
      .withConverter<AppUser>(
        fromFirestore: (snapshot, options) =>
            AppUser.fromJson(snapshot.data()!),
        toFirestore: (data, options) => data.toJson(),
      );

  CollectionReference<AboutUs> get aboutUs => _firestore
      .collection('about-us')
      .withConverter<AboutUs>(
        fromFirestore: (snapshot, options) =>
            AboutUs.fromJson(snapshot.data()!),
        toFirestore: (data, options) => data.toJson(),
      );

  CollectionReference<AppFile> get mediaLibraryVideos => FirebaseFirestore
      .instance
      .collection('media')
      .withConverter<AppFile>(
        fromFirestore: (snapshot, options) =>
            AppFile.fromJson(snapshot.data()!),
        toFirestore: (data, options) => data.toJson(),
      );

  CollectionReference<AppFile> get mediaLibraryFiles => FirebaseFirestore
      .instance
      .collection('media')
      .withConverter<AppFile>(
        fromFirestore: (snapshot, options) =>
            AppFile.fromJson(snapshot.data()!),
        toFirestore: (data, options) => data.toJson(),
      );
}
