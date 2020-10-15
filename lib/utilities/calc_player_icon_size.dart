// attempt at responsive player icon size
double calcPlayerSizeFromCameraPosition(double cameraZoom) {
  double playerSize;
  if (cameraZoom <= 17 && cameraZoom > 16.35) {
    playerSize = 8;
  } else if (cameraZoom <= 16.35 && cameraZoom > 15.35) {
    playerSize = 16;
  } else if (cameraZoom <= 15.35 && cameraZoom > 14.35) {
    playerSize = 32;
  } else if (cameraZoom <= 14.35) {
    playerSize = 64;
  } else {
    playerSize = 8;
  }
  return playerSize;
}
