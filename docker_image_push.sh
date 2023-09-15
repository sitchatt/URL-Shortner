#!/bin/bash

# Ask the user for Docker repository information
read -p "Enter your Docker repository name: " DOCKER_REPO
read -p "Enter your image name: " IMAGE_NAME
read -p "Enter your image tag: " IMAGE_TAG
read -p "Enter your container name: " CONTAINER_NAME
read -p "Enter your Docker username: " USER_NAME
echo -n "Enter your Docker password: "
stty -echo  # Turn off echoing
read DOCKER_PASSWORD
stty echo   # Turn echoing back on
echo  # Move to a new line after user input
#read -s -p "Enter your Docker password: " DOCKER_PASSWORD
read -p "Enter the Port you want to expose:" PORT

# Ask the user for the Dockerfile path
read -p "Enter the path to your Dockerfile: " DOCKERFILE_PATH

# Check if the provided Dockerfile path is valid
if [ ! -f "$DOCKERFILE_PATH" ]; then
  echo "Dockerfile not found at the specified path."
  exit 1
fi

# Step 1: Build the Docker image
echo "Step 1: Building Docker image..."
docker build -t $IMAGE_NAME:$IMAGE_TAG -f $DOCKERFILE_PATH .

# Step 2: Create a Docker container
echo "Step 2: Creating Docker container..."
docker run -d --name $CONTAINER_NAME -p $PORT:$PORT $IMAGE_NAME:$IMAGE_TAG

# Step 3: Push the Docker image to the repository
echo "Step 3: Pushing Docker image to repository..."
docker login -u  "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD}
docker tag $IMAGE_NAME:$IMAGE_TAG $DOCKER_REPO/$IMAGE_NAME:$IMAGE_TAG
docker push $DOCKER_REPO/$IMAGE_NAME:$IMAGE_TAG

# Step 4: Clean up - stop and remove the container
#echo "Step 4: Cleaning up..."
#docker stop $CONTAINER_NAME
#docker rm $CONTAINER_NAME

# Step 5: Remove the local image (optional)
# If you want to remove the local image after pushing it to the repository
# uncomment the following line.
#docker rmi $DOCKER_REPO/$IMAGE_NAME:$IMAGE_TAG

echo "Script completed successfully."

