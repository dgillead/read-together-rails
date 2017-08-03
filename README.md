# Read Together

[ ![Codeship Status for dgillead/read-together-rails](https://app.codeship.com/projects/e7b22100-5ab8-0135-f52d-2ee64a37f588/status?branch=master)](https://app.codeship.com/projects/237325)

## What is Read Together?

Read Together is a way for users to connect with other people and talk about some of their favorite books. Users can register for an account, and then either view public discussions that other users have made and comment on those, or create their own discussions. When a user creates their own discussion, they can either leave it private (the default), which will only allow users they invite by e-mail to participate in the discussion, or make the discussion public, which will allow any registered user to comment on the discussion. Read Together was built using Ruby on Rails and Bootstrap, and also utilizes the Disqus and Goodreads APIs.

You can check out the site here - https://together-we-read.herokuapp.com/


## Getting Started on your local machine

1. Clone the repo to your local machine.
```
$ git clone git@github.com:dgillead/read-together-rails.git
```

2. Run bundle install.
```
$ bundle install
```

3. Create and migrate the database.
```
$ bundle exec rails db:create
$ bundle exec rails db:migrate
```

4. In order for the site to work on your localhost, you'll need to create some environment variables for the ActionMailer info as well as the Goodreads API.
  * For ActionMailer, I would suggest creating a throwaway gmail e-mail address, as you'll have to go into the gmail account settings and allow less secure apps to access the account in order for the invite functionality to work.
  * Once the e-mail address is created, set the name of the e-mail to an environment variable named readtogether_email, and the password to an environment variable named readtogether_pass.
  * Head over to https://www.goodreads.com/api and request an API key.
  * Once you have your key, set the key to an environment variable name goodreads_key.

5. Start up the rails sever.
```
$ bundle exec rails s
```
