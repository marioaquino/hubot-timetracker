# Track time spent on stories by devs
#
# i am starting on <story number> - Start a timer for the given effort
# i am done with <story number> - Stop timer for the given effort
# show my timesheet - Display the time hubot has accumulated for you
# reset my timesheet - Clear all entries from my timesheet

class Timesheets
  constructor: (@robot) ->
    @cache = []

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.timesheets
        @cache = @robot.brain.data.timesheets

  add: (effort) ->

  retrieve: (name) ->

  clearFor: (name) ->


class Effort
  constructor: (@name, @id) ->

  duration: ->
    elapsed = 0 unless @startTime?()
    elapsed ?= @endTime().getMinutes() - @startTime().getMinutes()
    "#{elapsed} minute#{if elapsed == 1 then '' else 's'}#{if @isRunning() then ' (*)' else ''}"

  start: -> @starting = new Date()

  stop: -> @ending = new Date()

  endTime: -> @ending or new Date

  startTime: -> @starting

  isRunning: -> @starting? and  not @ending?


(module ?= {}).exports = (robot) ->

  timesheets = new Timesheets robot

  robot.respond /show my time(sheet)?/i, (msg) ->
    msg.send new Effort(msg.message.user).duration()

  robot.respond /i am starting on (\d+)/i, (msg) ->

    #msg.message.user.

  robot.respond /i am done with (\d+)/i, (msg) ->

(exports ? this).Effort = Effort
(exports ? this).Timesheets = Timesheets

