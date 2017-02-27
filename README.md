# inbox-server

Inbox is a small application to store and manage resources (URLs, text snippets, etc.)

## API

See [API.md](./API.md).

## Deployment

### Environment variables

```
BASIC_AUTH_USERNAME=MyUsername
BASIC_AUTH_PASSWORD=MySuperSecureP@ssw0rd
SECRET_KEY_BASE=12345
DATABASE_URL=foo-bar
```

### Heroku

```
$ heroku create foo-bar
$ heroku buildpacks:add https://github.com/HashNuke/heroku-buildpack-elixir
$ heroku buildpacks:add https://github.com/gjaldon/phoenix-static-buildpack
$ heroku addons:create heroku-postgresql
$ heroku config:set SECRET_KEY_BASE=`mix phoenix.gen.secret`
$ heroku config:set BASIC_AUTH_USERNAME=MyUsername
$ heroku config:set BASIC_AUTH_PASSWORD=MySuperSecureP@ssw0rd
$ heroku config:set ALLOW_ORIGIN=https://my-client.herokuapp.com/
$ git push heroku master
$ heroku run mix ecto.create # ignore the error
$ heroku run mix ecto.migrate
```

## Development

```
$ mix deps.get
$ mix phoenix.server
```

Use `john` username and `12345` password for development.

### Tests

```
$ mix test
```

## License

inbox-server is licensed under the MIT license.

See [LICENSE](./LICENSE) for the full license text.
