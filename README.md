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
