Split YBP MARC files for JHU Technical Services

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

Replace `/local/path/to/data` to the directory where the marc file is stored.
Replace `<marc_file>` to the name of the marc file (including the .mrc extenstion)

### Amalivre

```
docker run -v /local/path/to/data:/app/data jiaola/ybpsplit amalivre data/<marc_file>
```

Replace `/local/path/to/data` to the directory where the marc file is stored.
Replace `<marc_file>` to the name of the marc file (including the .mrc extenstion)

To pull new builds

    docker pull jiaola/ybpsplit
