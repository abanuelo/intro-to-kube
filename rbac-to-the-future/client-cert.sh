mkdir cert && cd cert
# pod read client certs
openssl genrsa -out podreader.key 2048
openssl req -new -key podreader.key -out podreader.csr -subj “/CN=podreader/O=podreader”
openssl x509 -req -in podreader.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out podreader.crt -days 500

# pod write client certs
openssl genrsa -out podwriter.key 2048
openssl req -new -key podwriter.key -out podwriter.csr -subj “/CN=podwriter/O=podwriter”
openssl x509 -req -in podwriter.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out podwriter.crt -days 500

# create user and contexts necessary
kubectl config set-credentials podreader --client-certificate=podreader.crt --client-key=podreader.key
kubectl config set-context podreader-context --user=podreader
kubectl config set-credentials podwriter --client-certificate=podwriter.crt --client-key=podwriter.key
kubectl config set-context podwriter-context --user=podwriter