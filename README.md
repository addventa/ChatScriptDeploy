# ChatScriptDeploy

This repository contains 2 useful scripts which install bots and different versions of ChatScript in dinstincts folders, this allows you to deploy the bot you want with any version of ChatScript.

- install.sh
- deploybot.sh

We also have a simple bot which will allows you to tryout our scripts without having to create a bot.

Follow the steps below to assimilate how the scripts works, as well as the automatic-release of travis.

## Install ChatScript on your Linux server

### How to use the script ?

```bash install.sh```

Specify the ChatScript version to download it, it's the 7.3 version by default.

![](https://media.giphy.com/media/3ohze2yobVnj7gCPBe/giphy.gif)

### What does the script do ?

- Create and set a default cron job for ChatScript.
- Download the ChatScript version selected in ChatScript folder.
- Create a symbolic link to the latest ChatScript version you installed.
- Create a symbolic link to your authorizedIP.txt

## Travis Releasing

### Prerequisites

You must have a bot, and his data must be organized like in this repository:
- BOTADATA/*.top
- files1.txt

### What does Travis do ?

There is a .travis.yml which is our travis file to auto-release the bot.
Travis is triggered at each commit on the branch 'master', execute the packaging script and create a release from a tag.

The .travis.yml file need the scripts in release folder to create and commit release on github.

* [Travis Documentation](https://docs.travis-ci.com/) - For more informations.

## Deploy a bot on your server

### Prerequisites

You must have a repository with github realeses of your bot.
If you don't know how to manage it, just read the Travis Releasing part.

### How to use the script ?

```bash deploy.sh [repository_of_your_bot]```

Specify the version released of your Bot you want to deploy, it's the latest version by default.
Enter your github token.

![](https://media.giphy.com/media/xUPGcr7tp9UylIxRHG/giphy.gif)

### What does the script do ?

- Download the Bot version selected in BOTS folder.
- Start or Restart your current Bot.
- Reset the cron job depending on the bot you just have deployed.
- We chose to put the folders TOPIC, USERS and LOGS in the Bot folder because this is specific to each bot, not to ChatScript; it is this organization that allows us to have a better logic in our architechture.
- Delete your private data (BOTDATA, files1.txt)

If you are looking for more info, you are free to read the code :).

### Final Tree Example

```
BOTS
 |------ HelloBot
          |------ BOTDATA*
          |------ LOGS
          |------ TOPIC
          |------ USERS
          |------ files1.txt*
CS
 |------ authorizedIP.txt
 |------ ChatScript -> ChatScript-7.3
 |------ ChatScript-7.3
 |------ ChatScript-7.1
          |------ authorizedIP.txt -> ../authorizedIP.txt
```

* *Deleted at the end of the deployment to not leave your own data.