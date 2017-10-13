Split YBP MARC files for JHU Technical Services

To run it from a windows machine:

    docker run -it -v C:/Users/username/path/to/data:/app/data jiaola/ybpsplit ./ybp.rb data/17501009.mrc

To pull new builds

    docker pull jiaola/ybpsplit
