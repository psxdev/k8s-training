# Exercise II

## NetworkPolicy 

We will create a more advanced wordpress frontend with 2 version of the image with mariadb backend in namespace exercise-02. A network policy limiting access from frontend pods is added. 

Delete name space first to asure it is not createt yet:

```
kubectl delete ns exercise-02
```

All is done in command.bash, execute:

```
./command.bash
```

You must modify your /etc/hosts and add wordpress-exercise-02.com entry with ip from kubectl cluster-info

Wait until all pods are ready:

```
kubectl get pods --namespace=exercise-02 --watch
NAME                                           READY     STATUS    RESTARTS   AGE
mariadb-66747794f6-4s56m                       1/1       Running   0          2m
wordpress-canary-deployment-759557b99f-xgt77   1/1       Running   0          2m
wordpress-deployment-687f4bb746-b7sbt          1/1       Running   0          2m
wordpress-deployment-687f4bb746-c5f8h          1/1       Running   0          2m
wordpress-deployment-687f4bb746-xmjd2          1/1       Running   0          2m
```


