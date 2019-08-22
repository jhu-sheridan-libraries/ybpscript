# TODO: Update the docker hub repo. 

Transform MARC files for JHU Technical Services

## Requirements

You need docker to run these scripts. For windows 7, install docker toolbox at https://docs.docker.com/toolbox/toolbox_install_windows/

Otherwise, just install docker community edition:

https://docs.docker.com/engine/installation/

## Installation and Update

To install or update the docker containers, use the following command:

```
docker pull jiaola/ybpsplit
```

## Instructions

### ybp

```
docker run -v /local/path/to/data:/app/data jiaola/ybpsplit ybp data/<marc_file>
```

Replace `/local/path/to/data` to the directory where the marc file is stored.
Replace `<marc_file>` to the name of the marc file (including the .mrc extenstion)

### Casalini

```
docker run -v /local/path/to/data:/app/data/casalini jiaola/ybpsplit casalini data/casalini
```

### Harrassowitz

```
docker run -v /local/path/to/data:/app/data jiaola/ybpsplit harrassowitz data/<marc_file>
```
Shoul
Replace `/local/path/to/data` to the directory where the marc file is stored.
Replace `<marc_file>` to the name of the marc file (including the .mrc extenstion)

### Amalivre

```
docker run -v /local/path/to/data:/app/data jiaola/ybpsplit amalivre data/<marc_file>
```

Replace `/local/path/to/data` to the directory where the marc file is stored.
Replace `<marc_file>` to the name of the marc file (including the .mrc extenstion)
