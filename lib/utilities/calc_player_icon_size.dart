// attempt at responsive player icon size
double calcPlayerSizeFromCameraPosition(double cameraZoom) {
  double playerSize;
  if (cameraZoom <= 17 && cameraZoom > 16.25) {
    playerSize = 8;
  } else if (cameraZoom <= 16.25 && cameraZoom > 15.25) {
    playerSize = 16;
  } else if (cameraZoom <= 15.25 && cameraZoom > 14.25) {
    playerSize = 32;
  } else if (cameraZoom <= 14.25) {
    playerSize = 64;
  } else {
    playerSize = 8;
  }
  return playerSize;
}
