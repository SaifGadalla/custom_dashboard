// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Reorder Columns`
  String get reorder_columns {
    return Intl.message(
      'Reorder Columns',
      name: 'reorder_columns',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Actions`
  String get actions {
    return Intl.message('Actions', name: 'actions', desc: '', args: []);
  }

  /// `No elements to display`
  String get no_elements_to_display {
    return Intl.message(
      'No elements to display',
      name: 'no_elements_to_display',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Articles`
  String get articles {
    return Intl.message('Articles', name: 'articles', desc: '', args: []);
  }

  /// `Article`
  String get article {
    return Intl.message('Article', name: 'article', desc: '', args: []);
  }

  /// `Services`
  String get services {
    return Intl.message('Services', name: 'services', desc: '', args: []);
  }

  /// `Service`
  String get service {
    return Intl.message('Service', name: 'service', desc: '', args: []);
  }

  /// `Welcome back`
  String get welcome_back {
    return Intl.message(
      'Welcome back',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Here's what's happening with your services and content today.`
  String get home_description {
    return Intl.message(
      'Here\'s what\'s happening with your services and content today.',
      name: 'home_description',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `About Us`
  String get about_us {
    return Intl.message('About Us', name: 'about_us', desc: '', args: []);
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Vision`
  String get vision {
    return Intl.message('Vision', name: 'vision', desc: '', args: []);
  }

  /// `Mission`
  String get mission {
    return Intl.message('Mission', name: 'mission', desc: '', args: []);
  }

  /// `Qualifications`
  String get qualifications {
    return Intl.message(
      'Qualifications',
      name: 'qualifications',
      desc: '',
      args: [],
    );
  }

  /// `Qualification`
  String get qualification {
    return Intl.message(
      'Qualification',
      name: 'qualification',
      desc: '',
      args: [],
    );
  }

  /// `Experience`
  String get experience {
    return Intl.message('Experience', name: 'experience', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `See more`
  String get see_more {
    return Intl.message('See more', name: 'see_more', desc: '', args: []);
  }

  /// `Add success`
  String get add_success {
    return Intl.message('Add success', name: 'add_success', desc: '', args: []);
  }

  /// `Edit success`
  String get edit_success {
    return Intl.message(
      'Edit success',
      name: 'edit_success',
      desc: '',
      args: [],
    );
  }

  /// `Delete success`
  String get delete_success {
    return Intl.message(
      'Delete success',
      name: 'delete_success',
      desc: '',
      args: [],
    );
  }

  /// `Service addition`
  String get service_addition {
    return Intl.message(
      'Service addition',
      name: 'service_addition',
      desc: '',
      args: [],
    );
  }

  /// `Service editing`
  String get service_editing {
    return Intl.message(
      'Service editing',
      name: 'service_editing',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Not Found`
  String get not_found {
    return Intl.message('Not Found', name: 'not_found', desc: '', args: []);
  }

  /// `Image`
  String get image {
    return Intl.message('Image', name: 'image', desc: '', args: []);
  }

  /// `Click to upload`
  String get click_to_upload {
    return Intl.message(
      'Click to upload',
      name: 'click_to_upload',
      desc: '',
      args: [],
    );
  }

  /// `Service details`
  String get service_details {
    return Intl.message(
      'Service details',
      name: 'service_details',
      desc: '',
      args: [],
    );
  }

  /// `Service details addition`
  String get service_details_addition {
    return Intl.message(
      'Service details addition',
      name: 'service_details_addition',
      desc: '',
      args: [],
    );
  }

  /// `Service details editing`
  String get service_details_editing {
    return Intl.message(
      'Service details editing',
      name: 'service_details_editing',
      desc: '',
      args: [],
    );
  }

  /// `Service details delete`
  String get service_details_delete {
    return Intl.message(
      'Service details delete',
      name: 'service_details_delete',
      desc: '',
      args: [],
    );
  }

  /// `Article addition`
  String get article_addition {
    return Intl.message(
      'Article addition',
      name: 'article_addition',
      desc: '',
      args: [],
    );
  }

  /// `Article editing`
  String get article_editing {
    return Intl.message(
      'Article editing',
      name: 'article_editing',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get item {
    return Intl.message('Item', name: 'item', desc: '', args: []);
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Content`
  String get content {
    return Intl.message('Content', name: 'content', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Drag and drop {value} here or`
  String drag_and_drop_description(int value) {
    return Intl.message(
      'Drag and drop $value here or',
      name: 'drag_and_drop_description',
      desc: '',
      args: [value],
    );
  }

  /// `Add {something}`
  String add_something_of(String something) {
    return Intl.message(
      'Add $something',
      name: 'add_something_of',
      desc: '',
      args: [something],
    );
  }

  /// `Edit {something}`
  String edit_something_of(String something) {
    return Intl.message(
      'Edit $something',
      name: 'edit_something_of',
      desc: '',
      args: [something],
    );
  }

  /// `Delete {something}`
  String delete_something_of(String something) {
    return Intl.message(
      'Delete $something',
      name: 'delete_something_of',
      desc: '',
      args: [something],
    );
  }

  /// `Last {something}`
  String last_something_of(String something) {
    return Intl.message(
      'Last $something',
      name: 'last_something_of',
      desc: '',
      args: [something],
    );
  }

  /// `Select {something}`
  String select_something_of(String something) {
    return Intl.message(
      'Select $something',
      name: 'select_something_of',
      desc: '',
      args: [something],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
