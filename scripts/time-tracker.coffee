# Track time spent on stories by devs
#
# i am starting <story number> - Start a timer for the given effort
# i am done with <story number> - Stop timer for the given effort
# show my timesheet - Display the time hubot has accumulated for you
# reset my timesheet - Clear all entries from my timesheet

class Timesheets
  constructor: (robot) ->
    @cache = []

    robot.brain.on 'loaded', =>
      if @robot.brain.data.timesheets
        @cache = @robot.brain.data.timesheets

  add: (effort) ->

  retrieve: (name) ->
    "I have no timesheet recorded for #{name}"

  clearFor: (name) ->


class Effort
  constructor: (@name, @id) ->

  duration: ->
    hours = @getHours()
    minutes = @getMinutes()
    hours_text = if hours.length == 0 then '' else "#{hours} and "
    "#{hours_text}#{minutes}"

  getHours: ->
    return "" unless @startTime?()
    elapsed = @endTime().getHours() - @startTime().getHours()
    return "" unless (elapsed > 0)
    "#{@formatTime(elapsed, 'hour')}"

  formatTime: (elapsed, label) ->
    "#{elapsed} #{label}#{@pluralize(elapsed)}"

  getMinutes: ->
    elapsed = 0 unless @startTime?()
    elapsed ?= @endTime().getMinutes() - @startTime().getMinutes()
    "#{@formatTime(elapsed, 'minute')}#{if @isRunning() then ' (*)' else ''}"

  pluralize: (elapsedTime) ->
    if elapsedTime == 1 then '' else 's'

  start: -> @starting = new Date()

  stop: -> @ending = new Date()

  endTime: -> @ending or new Date

  startTime: -> @starting

  isRunning: -> @starting? and not @ending?


(module ?= {}).exports = (robot) ->

  timesheets = new Timesheets robot

  robot.respond /show my time(sheet)?/i, (msg) ->
    msg.send new Effort(msg.message.user).duration()

  robot.respond /i am starting (.*)/i, (msg) ->

    #msg.message.user.

  robot.respond /i am done with (.*)/i, (msg) ->

(exports ? this).Effort = Effort
(exports ? this).Timesheets = Timesheets

