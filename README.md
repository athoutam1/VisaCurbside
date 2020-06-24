# VisaCurbside

## Flutter Setup

- Recommended to use the VSCode extension
  - Just hit "Run and Debug" in the debug menu on the left hand side toolbar
- If there are any issues with your flutter installation (missing dependencies), run `flutter doctor`
- [Installing Flutter](https://flutter.dev/docs/get-started/install)
- Make sure XCode is installed (after launching XCode for the first time it might ask you to download some additional tools)
  - Only use iOS simulators. We haven't setup firebase to work on android (yet)

## Api Setup

[Install yarn](https://classic.yarnpkg.com/en/docs/install/#mac-stable)

- It's like npm, but better. It's also best if we only use one package manager in the project, so let's use yarn. [Yarn vs Npm Commands](https://classic.yarnpkg.com/en/docs/migrating-from-npm/)
- Once you clone the project, `cd api/`

  - Run `yarn install` inside the `api/` directory to install node modules

- Create a `.env` file at the root of the `api/` folder with the following content:
  - You can use another user that isn't root if you want
  ```
  SQL_USER=root
  SQL_PASSWORD=ENTER_MY_SQL_PASSWORD_HERE
  ```
- Make sure MySQL is installed and running locally
- Run `yarn setupDB` to create a database locally and fill in default values.
- Run `yarn dev` to start the development server (restarts on saved changes)
