Polymer

  is: 'grapp-rest-resource',

  properties:
    url: {type: String}
    baseUrl: {type: String}
    params: {type: String, value: -> {}}
    resource: {type: Object, notify: true}
    indexUrl: {type: String}
    showUrl: {type: String}
    newUrl: {type: String}
    createUrl: {type: String}
    updateUrl: {type: String}
    destroyUrl: {type: String}
    memberUrl: {type: String}
    queryString: {type: String}
    indexQueryString: {type: String}
    showQueryString: {type: String}
    newQueryString: {type: String}
    createQueryString: {type: String}
    updateQueryString: {type: String}
    destroyQueryString: {type: String}
    memberQueryString: {type: String}
    headers: {type: Object, value: -> {}}
    token: {type: String},
    request: {type: Object}

  ready: ->
    @resource =
      index: =>
        new Promise (resolve, reject) =>
          @_sendRequest('GET', @indexUrl, @indexQueryString).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      show: (id) =>
        new Promise (resolve, reject) =>
          @_sendRequest('GET', @showUrl, @showQueryString, id).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      new: () =>
        new Promise (resolve, reject) =>
          @_sendRequest('GET', @newUrl, @newQueryString, null, 'new').then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      create: (data) =>
        new Promise (resolve, reject) =>
          @_sendRequest('POST', @createUrl, @createQueryString, null, data).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      update: (id, data) =>
        new Promise (resolve, reject) =>
          @_sendRequest('PUT', @updateUrl, @updateQueryString, id, data).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      destroy: (id) =>
        new Promise (resolve, reject) =>
          @_sendRequest('DELETE', @destroyUrl, @destroyQueryString, id).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

      memberAction: (id, action) =>
        new Promise (resolve, reject) =>
          @_sendRequest('PUT', @memberUrl, @memberQueryString, id, null, action).then (request) =>
            @_handleResponse request.response, request.xhr.status, resolve
          , =>
            @_handleError @request.xhr.response, @request.xhr.status, reject

  _prepareUrl: (url, queryString, params, id, action) ->
    url = @baseUrl + url if @baseUrl
    url += '?' + queryString if queryString
    params = JSON.parse(params) if typeof(params) == 'string'
    for name, value of params
      url = url.replace ":#{name}", value
    url = url.replace ':id', id || ''
    url = url.replace /\/\/+/g, '/'
    url = url.replace /^(\w+):\//, '$1://'
    url = url.replace /\/$/, ''
    if action
      url += "/#{action}"
    url

  _prepareHeaders: ->
    h = {'Accept': 'application/json', 'Content-Type': 'application/json'}
    for key, val of @headers
      h[key] = val
    h['Authorization'] = @token if @token
    h

  _sendRequest: (method, url, queryString, id = null, data = null, action = null) ->
    @request = @_createRequestElement()
    @request.send
      method: method
      url: @_prepareUrl url || @url, queryString || @queryString, @params, id, action
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
