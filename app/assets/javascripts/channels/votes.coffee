console.log "OK"

App.votes = App.cable.subscriptions.create "VotesChannel",
  connected: ->
    console.log "Connected"
    setTimeout =>
      @perform 'follow', question_id: 5
    , 1000

  received: (data) ->
    console.log "Received"
    console.log data
