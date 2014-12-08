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
