import 'dart:io';

class Photo {
  File? _file;
  String? _url;
  bool _hasBeenUploaded;

  File get file => _file!;
  String get url => _url!;
  bool get hasBeenUploaded => _hasBeenUploaded;

  Photo.file(this._file) : _hasBeenUploaded = false {
    assert(_file != null);
  }

  Photo.url(this._url) : _hasBeenUploaded = true {
    assert(_url != null);
  }

  set url(String url) {
    _file = null;
    _url = url;
    _hasBeenUploaded = true;
  }
}
