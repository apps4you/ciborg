# ciborg
**ciborg** is a docker image based on the latest `alpine` image that contains a collection of **useful apps &  tools** for common CI build scenarios.

# content
the following programs & tools are included and enabled by default:

### OS packages
- apache2-utils
- bash
- curl
- git
- httpie
- monit
- python3

### PYTHON modules
- ansible
- docker

### EXTERNAL tools
- goss testing framework (https://github.com/aelsabbahy/goss)
- hey program that sends some load to a web application (https://github.com/rakyll/hey)


# usage
you can call the installed programs directly from the image

### image location/names
the image is available from the following repositories:
- dockerhub: `ops4you/ciborg`
- gitlab: `registry.gitlab.com/ops4you/ciborg`

### use ansible
```bash
docker run --rm -it <IMAGE-NAME> ansible --version
docker run --rm -it <IMAGE-NAME> ansible-playbook --version
```

### use apache benchmark
```bash
docker run --rm -it <IMAGE-NAME> ab -V
docker run --rm -it <IMAGE-NAME> ab -n 10 -c 2 https://google.com/ | grep "Time per request:.*across all concurrent requests" | sed "s/.*: *\([0-9]*\)\..*/\1/"
```

### use goss
```bash
docker run --rm -it <IMAGE-NAME> goss --version
```
