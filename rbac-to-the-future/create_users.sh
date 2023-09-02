# location for cert keys
mkdir user_certs && cd user_certs

# create Jesus certs
openssl genrsa -out Jesus.key 2048
openssl req -new -key Jesus.key -out Jesus.csr -subj "/CN=Jesus/O=Jesus"
openssl x509 -req -in Jesus.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out Jesus.crt -days 10

# create Joey certs
openssl genrsa -out Joey.key 2048
openssl req -new -key Joey.key -out Joey.csr -subj "/CN=Joey/O=Joey"
openssl x509 -req -in Joey.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out Joey.crt -days 10

# create Jessica certs
openssl genrsa -out Jessica.key 2048
openssl req -new -key Jessica.key -out Jessica.csr -subj "/CN=Jessica/O=Jessica"
openssl x509 -req -in Jessica.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out Jessica.crt -days 10

# create Jules certs
openssl genrsa -out Jules.key 2048
openssl req -new -key Jules.key -out Jules.csr -subj "/CN=Jules/O=Jules"
openssl x509 -req -in Jules.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out Jules.crt -days 10

# create user and contexts necessary
kubectl config set-credentials Jesus --client-certificate=Jesus.crt --client-key=Jesus.key
kubectl config set-context Jesus-context --user=Jesus

kubectl config set-credentials Joey --client-certificate=Joey.crt --client-key=Joey.key
kubectl config set-context Joey-context --user=Joey

kubectl config set-credentials Jessica --client-certificate=Jessica.crt --client-key=Jessica.key
kubectl config set-context Jessica-context --user=Jessica

kubectl config set-credentials Jules --client-certificate=Jules.crt --client-key=Jules.key
kubectl config set-context Jules-context --user=Jules