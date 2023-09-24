#!/bin/bash

NAMES=`kubectl get pods -l "app=just-a-pod" -o=name`

for n in $NAMES
do
    echo ${n#"pod/"}
    kubectl cp log.sh ${n#"pod/"}:/tmp/log.sh
    kubectl exec ${n#"pod/"} -- /bin/sh -c "chmod 777 /tmp/log.sh && touch /tmp/foo.log"
    kubectl exec ${n#"pod/"} -- /bin/sh -c "/tmp/log.sh"
    kubectl cp ${n#"pod/"}:/tmp/foo.log ./foo.log-${n#"pod/"}
done