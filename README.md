# Application Challenge #

***

## **Level 1** ##

###Goal

* Create a small PORO application that will fetch sample data from API, convert it to given format and save to SQL. 
* Write tests for each component of your application using RSpec. 
* For testing - create a fake API server that will respond with API samples provided.

**Estimated time for completion: 6 - 8 hours**

###Business Specification

For this challenge, we want to collect statistics of web site visits, that is provided by an API server, and store it to a MySQL database for later usage.

A sample API server response is located at `samples/api_response.json`

The API response is an array containing multiple elements, each representing a `visit`. Each `visit` contains a nested array, called `actionDetails`, each element in that array represents a `pageview`.

**Models**

We need the data to be saved into 2 different tables: `visits` and `pageviews`.  

* Create migrations to create those tables.
* Create models `Visit` and `Pageview`. `Visit` is as associated with `Pageview` with a one-to-many relation.
* The API response field names are different from the table column names. These need to be mapped accordingly.
* Please use the mapping structure given below to assign source field values to target database columns.
* Ignore source fields that are not listed in the mapping structure below.

**Visits schema and mappings** 

```ruby
    t.string "evid"
    t.string "vendor_site_id"
    t.string "vendor_visit_id"
    t.string "visit_ip"
    t.string "vendor_visitor_id"
``` 

`visit element` => `visits table` field mapping:

```ruby
{
  'referrerName' => :evid,
  'idSite'       => :vendor_site_id,
  'idVisit'      => :vendor_visit_id,
  'visitIp'      => :visit_ip,
  'visitorId'    => :vendor_visitor_id
}
```

**`evid` column validation**

Please clean up the `referrerName` response field value before saving, it should validate with following regex:

`/\A[A-z0-9]{8}-[A-z0-9]{4}-[A-z0-9]{4}-[A-z0-9]{4}-[A-z0-9]{12}\z/` 

Note: If should not contain `evid_`.

**Pageviews schema and mappings**

```ruby
    t.bigint "visit_id"
    t.string "title"
    t.string "position"
    t.text "url"
    t.string "time_spent"
    t.decimal "timestamp", precision: 14, scale: 3
```

`pageview element` => `pageviews table` field mapping:

```ruby
{
  'url'       => :url,
  'pageTitle' => :title,
  'timeSpent' => :time_spent,
  'timestamp' => :timestamp
}
```

**Pageviews order**

Pageviews should be sorted by `timestamp` field, in ascending order.

**Position column**

For `pageview` you will need to add the `position` field which indicates `pageview` position in data source array.
Please ensure that pages are unique, and there are no duplicates.  

**Fake API server**

You will need to create a simple Fake API server for handling responses. The server should accept a get request, and respond with the JSON given in `samples/api_response.json`. We suggest to use Sinatra for creating a small inline server, but the final solution is up to you.

**Setup**

Please use the included docker-compose.yml to setup the environment for this challenge. It will spinup a ready-for-work ruby-2.5.5 and mysql containers linking each other.
Create a Gemfile with your required gems, before executing `docker-compose up`, as it will attempt to do `bundle install`.

###Requirements

+ Ruby MRI 2.5+
+ Rspec for tests (100% coverage)
+ Rubocop for linting ruby code
+ Simplecov for code coverage
+ ActiveRecord for models (arguable)
+ MySQL for database
+ Docker + docker-compose for containerization

###Deliverable

A project directory containing `app.rb` file, with the `call` method inside, that we can run inside Docker: 

```
docker build -t shastic_challenge .
docker run -it -v "$(pwd)"/:/app shastic_challenge
bash# bundle exec -r 'app.rb' -e 'call'
```
  
  or with Docker compose
  
```
docker-compose build
docker-compose up -d    
docker-compose exec shastic_challenge bundle exec -r 'app.rb' -e 'call'      
```

Executing above commands should create records in the MySQL database according to specification.
  
###Things this challenge evaluates

+ Application architecture (classes naming and placement, code split)
+ How candidate manages requirements of files
+ What gems candidate will choose
+ What patterns and best practices will be used (SRP, DRY, ServiceObject, Strategy, etc..)

***

# Application Challenge #

## **Level 2** ##

###Goal

Continuing from the application created back in *[Application Challenge - Level 1](https://bitbucket.org/shastic/coding-challenges/wiki/Application%20Challenge%20-%20Level%201)*:

+ Create a Rake task for deploying the application to AWS Lambda, using the ruby AWS SDK. 
+ Deploy the application to AWS Lambda, and make sure it works.

**Estimated time for completion: 6 - 8 hours**

**Setup**

Change `docker/app/Dockerfile` image source to `lambci/lambda:build-ruby2.5` as it's the closest image to AWS Lambda. You will need to install `mysql-devel` package there and copy mysql shared library to `lib` folder, in order to make the mysql client work on AWS Lambda.

###Requirements

+ Use exactly `lambci/lambda:build-ruby2.5` as source image
+ Use AWS Lambda for code execution
+ Use AWS RDS for MySQL database (use free tier and remember to terminate the DB instance when not using it to avoid any fees)

###Deliverable

A working AWS Lambda function that fetches a sample response from the fake API server (inline) and saves converted data to RDS.

###Things this challenge evaluates

+ AWS services knowledge
+ Dev Ops skills
+ Usage of environment variables