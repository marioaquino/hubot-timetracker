# Track time spent on stories by devs
#
# i am starting on <story number> - Start a timer for the given effort
# i am done with <story number> - Stop timer for the given effort
# show my timesheet - Display the time hubot has accumulated for you

class Effort
  constructor: (@name...) ->

  duration: ->
    elapsed = 0 unless @starting?
    elapsed ?= @endTime().getMinutes() - @startTime().getMinutes()
    "#{elapsed} minute#{if elapsed == 1 then '' else 's'}#{if @starting? and not @ending? then ' (*)' else ''}"

  start: -> @starting = new Date()

  stop: -> @ending = new Date()

  endTime: -> @ending or new Date

  startTime: -> @starting


(module ?= {}).exports = (robot) ->
  robot.respond /show my time(sheet)?/i, (msg) ->
    msg.send new Effort(msg.message.user).duration()

  robot.respond /i am starting on (\d+)/i, (msg) ->

    #msg.message.user.

  robot.respond /i am done with (\d+)/i, (msg) ->

(exports ? this).Effort = Effort
