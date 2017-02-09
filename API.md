FORMAT: 1A

# Inbox

Inbox is a simple [API](data:text,Application Programming Interface) to store
resources in the form of [URI](data:text,Uniform Resource Identifier)s.

# Group Resources

Endpoints related to resources in the API.

## Resource Collection [/resources]

### List all resources [GET]

+ Request As JSON
  + Headers
    + Accepts: application/json
  + Parameters
    + tags: `foo bar ~baz` (array[string], optional) - Filter resources by these tags

+ Response 200 (application/json)
    + Body
        {
            "resources": [
                {
                    "id": 42,
                    "uri": "https://www.example.com/foo",
                    "tags": ["foo", "bar"],
                    "created_at": "2016-11-11T08:40:51.620Z",
                    "updated_at": "2016-11-11T08:40:51.620Z"
                },
                {
                    "id": 54,
                    "uri": "https://www.example.com/bar",
                    "tags": ["foo", "bar"],
                    "created_at": "2016-11-11T08:40:51.620Z",
                    "updated_at": "2016-11-11T08:40:51.620Z"
                },
            ]
        }

+ Request As text
  + Headers
    + Accepts: text/plain
  + Parameters
    + tags: `foo bar ~baz` (array[string], optional) - Filter resources by these tags

+ Response 200 (text/plain)
    + Body
        https://www.example.com/foo foo bar
        https://www.example.com/bar foo bar

### Creates a resource [POST]

Create a new resource. It takes an URI representing the resource.

+ Request (application/x-www-form-urlencoded)
    + Body
       uri=https:%2F%2Fwww.example.com%2F

+ Response 201 (application/json)
    + Headers
        Location: /resources/42
    + Body
        {
            "resource": {
                "id": 42,
                "uri": "https://www.example.com/",
                "tags": ["foo", "bar"],
                "created_at": "2016-11-11T08:40:51.620Z",
                "updated_at": "2016-11-11T08:40:51.620Z"
            }
        }

+ Response 422 (application/json)
    + Body
        {
            "errors": {
                "uri": [
                    "can't be blank"
                ]
            }
        }

## Resource [/resources/{id}]

Work with a single resource

### Resource Details [GET]

Retrieve the details of one resource

+ Request
  + Parameters
      + id: `42` (number, required) - Identifier of a resource

+ Response 200 (application/json)
    + Body
        {
            "resource": {
                "id": 42,
                "uri": "http://example.com/",
                "tags": ["foo", "bar"],
                "created_at": "2016-11-11T08:40:51.620Z",
                "updated_at": "2016-11-11T08:40:51.620Z"
            }
        }

+ Response 404 (text/plain)

### Delete Resource [DELETE]

+ Request
  + Parameters
      + id: `42` (number, required) - Identifier of a resource

+ Response 204

+ Response 404 (text/plain)

## Tag Collection [/tags]

### List all tags [GET]

+ Request

+ Response 200 (application/json)
    + Body
        {
            "tags": [
                {
                    "name": "foo",
                    "group": "user",
                    "system": false
                },
                {
                    "name": "bar",
                    "group": "user",
                    "system": true
                }
            ]
        }

---

The end.
