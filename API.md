FORMAT: 1A

# Inbox

Inbox is a simple [API](data:text,Application Programming Interface) to store
resources in the form of [URI](data:text,Uniform Resource Identifier)s.

# Group Resources

Endpoints related to resources in the API.

## Resource Collection [/resources]

### List all resources [GET]

+ Response 200 (application/json)

    + Body

        {
            "data": [
                {
                    "id": 42,
                    "uri": "https://www.example.com/foo",
                    "created_at": "2016-11-11T08:40:51.620Z",
                    "updated_at": "2016-11-11T08:40:51.620Z"
                },
                {
                    "id": 54,
                    "uri": "https://www.example.com/bar",
                    "created_at": "2016-11-11T08:40:51.620Z",
                    "updated_at": "2016-11-11T08:40:51.620Z"
                },
            ]
        }

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
            "data": {
                "id": 42,
                "uri": "https://www.example.com/",
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

+ Parameters
    + id: `42` (number, required) - Identifier of a resource

+ Response 200 (application/json)

    + Body

        {
            "data": {
                "id": 42,
                "uri": "http://example.com/",
                "created_at": "2016-11-11T08:40:51.620Z",
                "updated_at": "2016-11-11T08:40:51.620Z"
            }
        }

+ Response 404 (text/plain)

### Delete Resource [DELETE]

+ Parameters
    + id: `42` (number, required) - Identifier of a resource

+ Response 204

+ Response 404 (text/plain)

---

The end.
