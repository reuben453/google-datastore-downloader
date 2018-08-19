# Google Datastore Downloader

This is a script for downloading data from Google Datastore by executing a GQL query.

It will output the data in csv format.

## Setup

This assumes you already have [rvm](https://rvm.io) up and running.

- Clone the repo.
- cd into the folder.
- Install the required ruby version if rvm complains that it is not available: `rvm install ruby-2.x.x`
- Run this command to install the bundler gem: `gem install bundler`
- Use bundler to install dependencies: `bundle install`

## Execute

- Run the script using:  
`DATASTORE_PROJECT=your-project-id DATASTORE_KEYFILE='path to keyfile.json' ruby datastore_downloader.rb "select * from kind limit 10"`  

    DATASTORE_PROJECT is the id of the project that you are accessing.

    DATASTORE_KEYFILE is the path to the json file which contains credentials of a
    user/service account with permissions to read from google datastore.

- You can also provide the credentials json directly as an environment variable.

    `DATASTORE_PROJECT=your-project-id DATASTORE_KEYFILE_JSON='credentials json' ruby datastore_downloader.rb "select * from kind limit 10"`

- You can also build/download a docker image and run it:

    Build it using: `docker build -t google-datastore-downloader .`

    Or download it from dockerhub: `docker pull reuben453/google-datastore-downloader`

    `docker run -e DATASTORE_PROJECT=project-id -e DATASTORE_KEYFILE_JSON='creds json' -it google-datastore-downloader "select * from table1 limit 10"`

## Current Limitations

- This script will throw an exception if all the data being downloaded does not have exactly the same column names.  
This can happen when downloading entities of different kinds together.