grapp-rest-resource
===================

A web component that encapsulates REST API calls.

Attributes
----------

  * **url**

    - *type:* string

    A pattern for the REST URL. Can contain colon-parameters and data bindings, for example:

    `url="/users/:userId?q={{searchText}}"`

    Default URLS:

    Method        | HTTP method | URL
    ------------- | ----------- | ---
    index         | GET         | /users
    show          | GET         | /users/1
    new           | GET         | /users/new
    create        | POST        | /users
    update        | PUT         | /users
    delete        | DELETE      | /users/1
    member foo    | PUT         | /users/1/foo

  * **params**

    - *type:* hash

    A hash that binds URL parameters to actual values, for example:

    `params='{{ {"userId":user.id} }}'`

  * **resource**

    - *type:* object binding

    Bind the REST ressource object to an object that can be passed around.

  * **indexUrl**

    - *type:* string

    Use this URL instead of the default one for "GET /resources" requests.

  * **showUrl**

    - *type:* string

    Use this URL instead of the default one for "GET /resources/:id" requests.

  * **newUrl**

    - *type:* string

    Use this URL instead of the default one for "GET /resources/:id" requests.

  * **createUrl**

    - *type:* string

    Use this URL instead of the default one for "POST /resources" requests.

  * **updateUrl**

    - *type:* string

    Use this URL instead of the default one for "PUT /resources/:id" requests.

  * **deleteUrl**

    - *type:* string

    Use this URL instead of the default one for "DELETE /resources/:id" requests.

  * **memberUrl**

    - *type:* string

    Use this URL instead of the default one for "PUT /resources/:id/action" requests.

  * **headers**

    - *type:* object

    Set additional headers on the request.

  * ** token**

    - *type:* string

    Set an authorization header with the specified token text.


Events
------

  * **grapp-authentication-error**

    Is fired when a REST API call returns a 401 error.


Resource Object methods
-----------------------

  * **index(successCallback, errorCallback)**

    Performs a HTTP GET on the index URL and returns the response data.

  * **show(id, successCallback, errorCallback)**

    Performs a HTTP GET on the show URL with the specified resource id and returns the response
    data.

  * **new(successCallback, errorCallback)**

    Performs a HTTP GET on the new URL and returns the response data.

  * **create(data, successCallback, errorCallback)**

    Performs a HTTP POST on the create URL with the specified resource data and returns
    the response data.

  * **update(id, data, successCallback, errorCallback)**

    Performs a HTTP PUT on the update URL with the specified resource id and data and returns
    the response data.

  * **delete(id, successCallback, errorCallback)**

    Performs a HTTP DELETE on the delete URL with the specified resource id and returns the response
    data.

  * **memberAction(id, action, successCallback, errorCallback)**

    Performs a HTTP PUT on the member URL with "/action" appended to it and the specified resource
    id and returns the response data.
