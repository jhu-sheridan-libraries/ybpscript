Split YBP MARC files for JHU Technical Services

To run it:

    docker run -v /path/to/data:/app/data jiaola/ybpsplit ybp data/17501009.mrc

    docker run -v /path/to/data:/app/data/folder jiaola/ybpsplit casalini data/folder

To pull new builds

    docker pull jiaola/ybpsplit
