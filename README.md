# Dynalist Automations

A collection of small features that assist my personal use of dynalist.io.

## Features

All these are currently only available in the specified `MAIN_DOCUMENT` (see Deployment).

### Daily reminders

Every day it will send a summary of bullets marked with today's date to the specified email address.

### Sorting

All bullets marked with `#sort_by_date` will have its children sorted by timestamps.

## Deployment

- Get an API key from https://dynalist.io/developer
- Find out the id of the document you want to watch (visible in the link URL when viewing that document)
- Create a Heroku dyno
- Attatch a Heroku Scheduler resource, set it to every day when it suits you and set the command to `bundle exec rake send_notification`

```
# Log into Heroku
heroku login

# Attatch the project to the Dyno you created
heroku git:remote -a <your heroku dynos id>

# Deploy the project
git push heroku master

# Set the ENV variables
heroku config:set EMAIL_RECEIVER=your_email@email.com
heroku config:set EMAIL_ADDRESS=email_sender@email.com
heroku config:set EMAIL_PASSWORD="password"
heroku config:set DYNALIST_API_BASE=https://dynalist.io/api/v1
heroku config:set DYNALIST_API_TOKEN=your_api_token
heroku config:set MAIN_DOCUMENT=AABBBCCC

# Manually run the rake task to see if it works
heroku run rake send_notification
```

### Using GMail

Google will most likely block sending emails from Heroku on the first attempt. You need to log into your account and confirm that the server is yours after trying.

You may have to go to https://accounts.google.com/DisplayUnlockCaptcha in incognito mode, logged into that account.

## Development

```
# Install dependencies
bundle

# Run the tests
bundle exec rake test
```

## Resources

- [Dynalist API docs](https://apidocs.dynalist.io/)
