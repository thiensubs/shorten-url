# README

This README would normally document whatever steps are necessary to get the
application up and running.

You must install Docker and Docker Compose. This project using MongoDB base on Docker-Compose, so

  ```docker-compose up -d --build``` to setup MongoDB.

Things you may want to cover:
* Rails 6

* Ruby version: 2.7.4

* System dependencies: ```bundle -j 6```

* Configuration:
  
  This application using mongodb, please make sure the mongodb installed and runned.

* How to run the test suite 

    
  1. ```bundle exec rspec ```

  2. ```bundle exec rspec spec/request```

  3. ```models, activejob (jobs), integrated test (features) ...```

   
(Development options)
* Run Rails application: 
  ```rails s```

* Run webpack:
  ```./bin/webpack-dev-server```

* Visit the applicaion
  ```localhost:3000``` via Web Browser

Production
* URL live:

  ```Deploy heroku if needed```

Visit the API Documentation

  ```localhost:3000/api/doc``


## SHORTEN URL Algorithm.

Take a deep look at app/models/my_link.rb
  
The main logic to generate the shorter URL are :

  - Save the long URL to DB using MongoID (Data-Mapper), you can use the long_url to split it array of chars. But I use the global_id string for the next step.
  - Next step, transferring the array of chars to the array with content has defined each element as ord(char).
  - Next, transfer the array with content has defined each element is ord(char) to cumsum (cumulative sum) array.
  - Next, Calculate the sum of cumsum array.
  - Using Bijective_numeration idea [https://en.wikipedia.org/wiki/Bijective_numeration] make named `bijective_encode` in my_link.rb to get the short URL.

