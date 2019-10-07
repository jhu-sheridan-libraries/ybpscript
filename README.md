
Transform MARC files for JHU Technical Services

## Requirements

You need docker to run these scripts. For windows 7, install docker toolbox at https://docs.docker.com/toolbox/toolbox_install_windows/

Otherwise, just install docker community edition:

https://docs.docker.com/engine/installation/

## Installation and Update

To install or update the docker containers, use the following command:

```
docker pull jhulibraries/ybpscript
```

## Instructions

### ybp

```
docker run -v /local/path/to/data:/app/data jhulibraries/ybpscript ybp data/<marc_file>
```

Replace `/local/path/to/data` to the directory where the marc file is stored.
Replace `<marc_file>` to the name of the marc file (including the .mrc extenstion)

### Casalini

```
docker run -v /local/path/to/data:/app/data/casalini jhulibraries/ybpscript casalini data/casalini
*windows syntax: docker run -v C:/folder:/app/data/casalini jhulibraries/ybpscript casalini data/casalini
```

### Harrassowitz

```
docker run -v /local/path/to/data:/app/data jhulibraries/ybpscript harrassowitz data/<marc_file>
docker run -v C:/folder:/app/data jhulibraries/ybpscript harrassowitz data/<marc_file>
```
Shoul
Replace `/local/path/to/data` to the directory where the marc file is stored.
Replace `<marc_file>` to the name of the marc file (including the .mrc extenstion)

### Amalivre

```
docker run -v /local/path/to/data:/app/data jhulibraries/ybpscript amalivre data/<marc_file>
docker run -v C:/folder:/app/data jhulibraries/ybpscript amalivre data/<marc_file>
```

Replace `/local/path/to/data` to the directory where the marc file is stored. Please note that Windows syntax varies (see above)
Replace `<marc_file>` to the name of the marc file (including the .mrc extenstion)

## Developers Guide

After clone the github repo, build the docker image: 

```
cd ybpscript
docker build -t jhulibraries/ybpscript .
```

List local docker images, you should see `jhulibraries/ybpscript`

```
docker images
```

Push the docker image to docker hub. You may need to login first with `docker login`

```
docker push jhulibraries/ybpscript:latest
```
