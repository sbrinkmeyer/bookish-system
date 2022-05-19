# bookish-system

# overview
Why the heck?  well you got a log location that is not in json format and or you got physical files that refuse to get up off your k8s pod's couch and off in to the elk/efk/e?k stack to do something with their lives.

this small container and tailer are an operations dream.  this is a real (fake) world example of a side car container doing real work with a shared file system between the two

## build and stuff
get minikube
do this
 echo "`minikube ip` docker.local" | sudo tee -a /etc/hosts > /dev/null
put this in your shell resource stuff
eval $(minikube docker-env)

then you can fire up minikube
use minikube to build the docker alpine minikube thing
`docker build -t sbrinkmeyer/alpine:latest -t sbrinkmeyer/alpine:1.2 .`

now you got a local alpine image withg the logger-tailer.sh on it as well as the inotifywait

now kubectl apply the yaml
`kubectl apply -f alpine2.yaml`

this creates a pod with 2 containers.  theoretically you can test the entire thing in one container
```
docker run -it sbrinkmeyer/alpine:latest bash
#in the shell
./logger-tailer.sh logger &
./logger-tailer.sh tailer &
#wait for the awesome
```

## as is
this works as is.  minimal change would be needed to consume this
* add the dockerfile to your pipeline
* add the logger-tailer to your src
* add the second container to your pod
* update the pod to share the log location
  * spec.template.spec.volumes.[0].name & 'emptyDir: {}'
  * spec.template.spec.containers
  * spec.template.spec.containers.[0].volumeMounts[0].name & mountPath
  * spec.template.spec.containers.[1].volumeMounts[0].name & mountPath
* update the pod to have sidecar and just have it run the tattler.sh with the tattler arg
  *     command: ["/logger-tailer.sh"]
        args: ["tailer"]

the great thing is it would be very easy to change the dockerfile and have logger-tailer.sh just be "tailer.sh" and all it does is the "tailer" function (which goes on forever).  then you would not need a command and args section

## next steps
1) put the actual sed in the tailer section to emit json and not just the pseudo comment code of this is where you do this.
1) create a config file as well that you can add to this, pass in as a parameter, ... hard wire whatever suits your boat, that has the sed regex needed to change you ugly boring log file in to a lovely dynamic namespaced json log output
1) the config could also describe which log location(s) to watch
1) probably something else i'm forgetting