grapp-rest-resource
===================

A web component that encapsulates REST API calls.

Compatible with Polymer 1.0+

Properties
----------

  * **baseUrl**

    - *type:* string
    
    The base url of all requests (e.g. https://api.exmaple.com:8000). 

  * **path**

    - *type:* string

    A pattern for the url path. Can contain colon-parameters and data bindings, for example:

    `path="/users/:userId"`

    Default paths:

    Method        | HTTP method | URL
    ------------- | ----------- | ---
    index         | GET         | /users
    show          | GET         | /users/1
    new           | GET         | /users/new
    create        | POST        | /users
    update        | PUT         | /users
    destroy       | DELETE      | /users/1
    member foo    | PUT         | /users/1/foo
    
    The method names are based on the corresponding controller methods of Ruby on Rails. 

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

  * **showPath**

    - *type:* string

    Use this URL instead of the default one for "GET /resources/:id" requests.

  * **newPath**

    - *type:* string

    Use this URL instead of the default one for "GET /resources/:id" requests.

  * **createPath**

    - *type:* string

    Use this URL instead of the default one for "POST /resources" requests.

  * **updatePath**

    - *type:* string

    Use this URL instead of the default one for "PUT /resources/:id" requests.

  * **destroyPath**

    - *type:* string

    Use this URL instead of the default one for "DELETE /resources/:id" requests.

  * **memberPath**

    - *type:* string

    Use this URL instead of the default one for "PUT /resources/:id/action" requests.

  * **query**

    - *type:* string

    A query string (without the '?') that is appended to the general url. 

  * **indexQuery**

    - *type:* string

    A query string (without the '?') that is appended to the indexPath. 

  * **showQuery**

    - *type:* string

    A query string (without the '?') that is appended to the showPath. 

  * **newQuery**

    - *type:* string

    A query string (without the '?') that is appended to the newPath. 

  * **createQuery**

    - *type:* string

    A query string (without the '?') that is appended to the createPath. 

  * **updateQuery**

    - *type:* string

    A query string (without the '?') that is appended to the updatePath. 

  * **destroyQuery**

    - *type:* string

    A query string (without the '?') that is appended to the destroyPath. 

  * **memberQuery**

    - *type:* string

    A query string (without the '?') that is appended to the memberPath. 

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

  In the following 'response object' means

  ```
  {
    data: <The response data>,
    status: <The response status code>
  }
  ```
	
  * **index(successCallback, errorCallback)**

    Performs a HTTP GET on the index URL and returns a promise that is resolved with a response object.


  * **show(id, successCallback, errorCallback)**

    Performs a HTTP GET on the show URL with the specified resource id and returns a promise that is
    resolved with a response object.


  * **new(successCallback, errorCallback)**

    Performs a HTTP GET on the new URL and returns a promise that is resolved with the a response object.


  * **create(data, successCallback, errorCallback)**

    Performs a HTTP POST on the create URL with the specified resource data and returns a promise that
    is resolved with a response object.


  * **update(id, data, successCallback, errorCallback)**

    Performs a HTTP PUT on the update URL with the specified resource id and data and returns a promise 
    that is resolved with a response object.


  * **destroy(id, successCallback, errorCallback)**

    Performs a HTTP DELETE on the destroy URL with the specified resource id and returns a promise that
    is resolved with a response object.


  * **memberAction(id, action, successCallback, errorCallback)**

    Performs a HTTP PUT on the member URL with "/action" appended to it and the specified resource
    id and returns a promise that is resolved with a response object.


  In case of an HTTP error the promise is rejected with a response object.
