String getFileType(String text) {
  if (text.contains('image/jpeg') ||
      text.contains('image/png') ||
      text.contains('image/jpg')) {
    return 'image';
  } else if (text.contains('video/mp4') || text.contains('video/mpeg')) {
    return 'video';
  } else {
    return 'other';
  }
}
