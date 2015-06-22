prepareUrl = (url, params = {}, id = null, action = null) ->
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


Polymer

  is: 'grapp-rest-resource',

  properties:
    url: {type: String}
    params: {type: String}
    resource: {type: Object}
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
        self.$.request.send
          url: prepareUrl self.indexUrl || self.url, self.params
          headers: self.prepareHeaders()
        .then (request) ->
          json = (if request.response.trim() != '' then JSON.parse request.response else {})
          switch request.xhr.status
            when 200 then success? json
            when 401 then self.fire 'grapp-authentication-error'
            else
              error? json

      show: (id, success, error) ->
        self.$.request.send
          url: prepareUrl self.showUrl || self.url, self.params, id
          headers: self.prepareHeaders()
        .then (request) ->
          json = (if request.response.trim() != '' then JSON.parse request.response else {})
          switch request.xhr.status
            when 200 then success? json
            when 401 then self.fire 'grapp-authentication-error'
            else
              error? json

      new: (success, error) ->
        self.$.request.send
          url: prepareUrl self.newUrl || self.url, self.params, null, 'new'
          headers: self.prepareHeaders()
        .then (request) ->
          json = (if request.response.trim() != '' then JSON.parse request.response else {})
          switch request.xhr.status
            when 200 then success? json
            when 401 then self.fire 'grapp-authentication-error'
            else
              error? json

      create: (data, success, error) ->
        self.$.request.send
          method: 'POST'
          url: prepareUrl self.createUrl || self.url, self.params
          headers: self.prepareHeaders()
          body: JSON.stringify data
        .then (request) ->
          json = (if request.response.trim() != '' then JSON.parse request.response else {})
          switch request.xhr.status
            when 200, 201, 204 then success? json
            when 401 then self.fire 'grapp-authentication-error'
            else
              error? json

      update: (id, data, success, error) ->
        self.$.request.send
          method: 'PUT'
          url: prepareUrl self.updateUrl || self.url, self.params, id
          headers: self.prepareHeaders()
          body: JSON.stringify data
        .then (request) ->
          json = (if request.response.trim() != '' then JSON.parse request.response else {})
          switch request.xhr.status
            when 200, 201, 204 then success? json
            when 401 then self.fire 'grapp-authentication-error'
            else
              error? json

      destroy: (id, success, error) ->
        self.$.request.send
          method: 'DELETE'
          url: prepareUrl self.destroyUrl || self.url, self.params, id
          headers: self.prepareHeaders()
        .then (request) ->
          json = (if request.response.trim() != '' then JSON.parse request.response else {})
          switch request.xhr.status
            when 200 then success? json
            when 401 then self.fire 'grapp-authentication-error'
            else
              error? json

      memberAction: (id, action, success, error) ->
        self.$.request.send
          method: 'PUT'
          url: prepareUrl self.memberUrl || self.url, self.params, id, action
          headers: self.prepareHeaders()
        .then (request) ->
          switch request.xhr.status
            when 200 then success?()
            when 401 then self.fire 'grapp-authentication-error'
            else
              error?()

  prepareHeaders: ->
    h = {'Accept': 'application/json'}
    for key, val of @headers
      h[key] = val
    h['Authorization'] = @token if @token
    h
