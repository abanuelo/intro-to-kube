FROM gitpod/workspace-base:latest

# Now run to start:

# docker-compose up -d
# Login to container:

# docker exec -it test-kuber bash
# And now you can start minikube:

# minikube start --driver=docker --force
# force is needed to use minikube from root (that's ok for me, but you may need some extra work to avoid it)

# When you are done, run from within the container:

# minikube delete
# Exit the container and run:

# docker-compose down
