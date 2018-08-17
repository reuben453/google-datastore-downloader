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
- Run the script using:  
`DATASTORE_PROJECT=your-project-id DATASTORE_KEYFILE='path to keyfile.json' ruby datastore_downloader.rb "select * from kind limit 10"`  

    DATASTORE_PROJECT is the id of the project that you are accessing.

    DATASTORE_KEYFILE is the path to the json file which contains credentials of a
    user/service account with permissions to read from google datastore.

## Current Limitations

- This script will throw an exception if all the data being downloaded does not have exactly the same column names.  
This can happen when downloading entities of different kinds together.

- Will not work well with large data sets since all the data is held in memory.