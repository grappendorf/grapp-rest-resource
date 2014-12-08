prepareUrl = (url, params = {}, id = null, action = null) ->
  params = JSON.parse(params) if typeof(params) == 'string'
  for name, value of params
    url = url.replace ":#{name}", value
  url = url.replace ':id', id || ''
  url = url.replace /\/\/+/, '/'
  url = url.replace /\/$/, ''
  if action
    url += "/#{action}"
  url


Polymer 'grapp-rest-resource',

  created: ->
    @url = ''
    @params = null
    self = @

    @resource =
      index: (success, error) ->
        self.$.xhr.request
          url: prepareUrl self.url, self.params
          headers: {'Accept': 'application/json'}
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      show: (id, success, error) ->
        self.$.xhr.request
          url: prepareUrl self.url, self.params, id
          headers: {'Accept': 'application/json'}
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      update: (id, data, success, error) ->
        self.$.xhr.request
          method: 'PUT'
          url: prepareUrl self.url, self.params, id
          headers: {'Accept': 'application/json'}
          body: JSON.stringify data
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      create: (data, success, error) ->
        self.$.xhr.request
          method: 'POST'
          url: prepareUrl self.url, self.params
          headers: {'Accept': 'application/json'}
          body: JSON.stringify data
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      delete: (id, success, error) ->
        self.$.xhr.request
          method: 'DELETE'
          url: prepareUrl self.url, self.params, id
          headers: {'Accept': 'application/json'}
          callback: (data, response) ->
            json = (if data.trim() != '' then JSON.parse data else {})
            switch response.status
              when 200 then success? json
              when 401 then self.fire 'grapp-authentication-error'
              else
                error? json

      memberAction: (id, action, success, error) ->
        self.$.xhr.request
          method: 'PUT'
          url: prepareUrl self.url, self.params, id, action
          headers: {'Accept': 'application/json'}
          callback: (data, response) ->
            switch response.status
              when 200 then success?()
              when 401 then self.fire 'grapp-authentication-error'
              else
                error?()
