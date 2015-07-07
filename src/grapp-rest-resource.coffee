Polymer

  is: 'grapp-rest-resource',

  properties:
    url: {type: String}
    params: {type: String, value: {}}
    resource: {type: Object, notify: true}
    indexUrl: {type: String}
    showUrl: {type: String}
    newUrl: {type: String}
    createUrl: {type: String}
    updateUrl: {type: String}
    destroyUrl: {type: String}
    memberUrl: {type: String}
    headers: {type: Object, value: {}}
    token: {type: String}

  ready: ->
    self = @

    @resource =
      index: (success, error) ->
        self._sendRequest('GET', self.indexUrl).then (request) ->
          self._handleResponse request.response, request.xhr.status, success, error

      show: (id, success, error) ->
        self._sendRequest('GET', self.showUrl, id).then (request) ->
          self._handleResponse request.response, request.xhr.status, success, error

      new: (success, error) ->
        self._sendRequest('GET', self.newUrl, null, 'new').then (request) ->
          self._handleResponse request.response, request.xhr.status, success, error

      create: (data, success, error) ->
        self._sendRequest('POST', self.createUrl, null, data).then (request) ->
          self._handleResponse request.response, request.xhr.status, success, error

      update: (id, data, success, error) ->
        self._sendRequest('PUT', self.updateUrl, id, data).then (request) ->
          self._handleResponse request.response, request.xhr.status, success, error

      destroy: (id, success, error) ->
        self._sendRequest('DELETE', self.destroyUrl, id).then (request) ->
          self._handleResponse request.response, request.xhr.status, success, error

      memberAction: (id, action, success, error) ->
        self._sendRequest('PUT', self.memberUrl, id, action).then (request) ->
          self._handleResponse request.response, request.xhr.status, success, error

  _prepareUrl: (url, params, id, action) ->
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
    h = {'Accept': 'application/json'}
    for key, val of @headers
      h[key] = val
    h['Authorization'] = @token if @token
    h

  _sendRequest: (method, url, id = null, data = null, action = null) ->
    @$.request.send
      method: method
      url: @_prepareUrl url || @url, @params, id, action
      headers: @_prepareHeaders()
      body: (if data then JSON.stringify data else undefined)

  _handleResponse: (response, status, success, error) ->
    json = (if response && response.trim() != '' then JSON.parse response else {})
    if status >= 200 && status <= 299
      success? json
    else if status == 401
      self.fire 'grapp-authentication-error'
    else
      error? json
