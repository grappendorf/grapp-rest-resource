grapp-rest-resource
===================

A web component that encapsulates REST API calls.

Attributes
----------

  * **url**

    - *type:* string

    A pattern for the REST URL. Can contain colon-parameters and data bindings, for example:

    `url="/users/:userId?q={{searchText}}"`

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


Events
------

  * **grapp-authentication-error**

    Is fired when a REST API call returns a 401 error.
