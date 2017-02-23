# inbox-server

Inbox is a small application to store and manage resources (URLs, text snippets, etc.)

## API

See [API.md](./API.md).

## Deployment

### HTTP BASIC AUTH configuration

```
BASIC_AUTH_USERNAME=MyUsername
BASIC_AUTH_PASSWORD=MySuperSecureP@ssw0rd
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
