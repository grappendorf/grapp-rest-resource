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
    token: {type: String},
    request: {type: Object}

  ready: ->
    self = @

    @resource =
      index: ->
        new Promise (resolve, reject) ->
          self._sendRequest('GET', self.indexUrl).then (request) ->
            self._handleResponse request.response, request.xhr.status, resolve
          , ->
            self._handleError self.request.xhr.response, self.request.xhr.status, reject

      show: (id) ->
        new Promise (resolve, reject) ->
          self._sendRequest('GET', self.showUrl, id).then (request) ->
            self._handleResponse request.response, request.xhr.status, resolve
          , ->
            self._handleError self.request.xhr.response, self.request.xhr.status, reject

      new: () ->
        new Promise (resolve, reject) ->
          self._sendRequest('GET', self.newUrl, null, 'new').then (request) ->
            self._handleResponse request.response, request.xhr.status, resolve
          , ->
            self._handleError self.request.xhr.response, self.request.xhr.status, reject

      create: (data) ->
        new Promise (resolve, reject) ->
          self._sendRequest('POST', self.createUrl, null, data).then (request) ->
            self._handleResponse request.response, request.xhr.status, resolve
          , ->
            self._handleError self.request.xhr.response, self.request.xhr.status, reject

      update: (id, data) ->
        new Promise (resolve, reject) ->
          self._sendRequest('PUT', self.updateUrl, id, data).then (request) ->
            self._handleResponse request.response, request.xhr.status, resolve
          , ->
            self._handleError self.request.xhr.response, self.request.xhr.status, reject

      destroy: (id) ->
        new Promise (resolve, reject) ->
          self._sendRequest('DELETE', self.destroyUrl, id).then (request) ->
            self._handleResponse request.response, request.xhr.status, resolve
          , ->
            self._handleError self.request.xhr.response, self.request.xhr.status, reject

      memberAction: (id, action) ->
        new Promise (resolve, reject) ->
          self._sendRequest('PUT', self.memberUrl, id, action).then (request) ->
            self._handleResponse request.response, request.xhr.status, resolve
          , ->
            self._handleError self.request.xhr.response, self.request.xhr.status, reject

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
    h = {'Accept': 'application/json', 'Content-Type': 'application/json'}
    for key, val of @headers
      h[key] = val
    h['Authorization'] = @token if @token
    h

  _sendRequest: (method, url, id = null, data = null, action = null) ->
    @request = @_createRequestElement()
    @request.send
      method: method
      url: @_prepareUrl url || @url, @params, id, action
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
