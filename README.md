# Player Database

The API for [scorebook_ui](https://github.com/hoitomt/scorebook-ui)

## API Access

1. Register a new user
2. Go into the Rails console and generate an api_key

    ```
    u = User.last
    u.generate_api_key
    => "ABC123"
    ```

3. Query the API: example curl request

    ```
    curl -H 'Authorization: Token token="ABC123"' http://localhost:3000/api/v1/teams
    ```
