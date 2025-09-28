# notes

This is a separate creation and management pipeline & terraform project to allow for the ecr to be available with a built image with fixed tag, before we try to hook up the app runner. 

The app runner will try to pull the image the first time the service is created and will fail if it is not there.
