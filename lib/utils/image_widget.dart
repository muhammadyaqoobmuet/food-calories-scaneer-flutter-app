// Facade that chooses the correct implementation for the current platform.
// Uses conditional import: the web implementation is used when `dart.library.html` is
// available; otherwise the IO implementation is used.
export 'image_widget_io.dart' if (dart.library.html) 'image_widget_web.dart';

// The exported file exposes `buildImageWidget`.
