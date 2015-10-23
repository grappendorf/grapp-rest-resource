Polymer

  is: 'grapp-rest-resource',

  properties:
    path: {type: String}
    baseUrl: {type: String}
    params: {type: String, value: -> {}}
    resource: {type: Object, notify: true}
    indexPath: {type: String}
    showPath: {type: String}
    newPath: {type: String}
    createPath: {type: String}
    updatePath: {type: String}
    destroyPath: {type: String}
    memberPath: {type: String}
    query: {type: String}
    indexQuery: {type: String}
    showQuery: {type: String}
    newQuery: {type: String}
    createQuery: {type: String}
    updateQuery: {type: String}
    destroyQuery: {type: String}
    memberQuery: {type: String}
    headers: {type: Object, value: -> {}}
    token: {type: String},
    request: {type: Object}

  ready: ->
    @resource =
      index: =>
        new Promise (resolve, reject) =>
          @_sendRequest('GET', @indexPath, @indexQuery).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      show: (id) =>
        new Promise (resolve, reject) =>
          @_sendRequest('GET', @showPath, @showQuery, id).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      new: () =>
        new Promise (resolve, reject) =>
          @_sendRequest('GET', @newPath, @newQuery, null, null, 'new').then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      create: (data) =>
        new Promise (resolve, reject) =>
          @_sendRequest('POST', @createPath, @createQuery, null, data).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      update: (id, data) =>
        new Promise (resolve, reject) =>
          @_sendRequest('PUT', @updatePath, @updateQuery, id, data).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      destroy: (id) =>
        new Promise (resolve, reject) =>
          @_sendRequest('DELETE', @destroyPath, @destroyQuery, id).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      memberAction: (id, action) =>
        new Promise (resolve, reject) =>
          @_sendRequest('PUT', @memberPath, @memberQuery, id, null, action).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

  _prepareUrl: (path, query, params, id, action) ->
    url = if @baseUrl then @baseUrl + path else path
    params = JSON.parse(params) if typeof(params) == 'string'
    if action
      url += "/#{action}"
    url += '?' + query if query
    for name, value of params
      url = url.replace ":#{name}", value
    url = url.replace ':id', id || ''
    url = url.replace /\/\/+/g, '/'
    url = url.replace /^(\w+):\//, '$1://'
    url = url.replace /\/$/, ''
    url

  _prepareHeaders: ->
    h = {'accept': 'application/json', 'content-type': 'application/json'}
    for key, val of @headers
      h[key] = val
    h['authorization'] = @token if @token
    h

  _sendRequest: (method, path, query, id = null, data = null, action = null) ->
    @request = @_createRequestElement()
    @request.send
      method: method
      url: @_prepareUrl path || @path, query || @query, @params, id, action
      headers: @_prepareHeaders()
      body: (if data then JSON.stringify data else undefined)

  _createRequestElement: ->
    document.createElement 'iron-request'

  _handleResponse: (response, status, resolve) ->
    json = (if response && response.trim() != '' then JSON.parse response else {})
    resolve data: json, status: status

  _handleError: (response, status, reject) ->
    json = (if response && response.trim() != '' then JSON.parse response else {})
    if status == 401
      @fire 'grapp-authentication-error'
      reject data: json, status: status
    else
      reject data: json, status: status
