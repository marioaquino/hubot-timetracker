# Track time spent on stories by devs
#
# i am starting <story number> - Start a timer for the given effort
# i am done with <story number> - Stop timer for the given effort
# show my timesheet - Display the time hubot has accumulated for you
# reset my timesheet - Clear all entries from my timesheet

class Timesheets
  #TODO: Is it necessary to hold on to @robot?
  constructor: (@robot) ->
    @cache = {}

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.timesheets
        @cache = @robot.brain.data.timesheets

  add: (effort) ->
    (@cache[effort.participant] ||= []).push effort
    effort.start()

  retrieve: (participant) ->
    return "I have no timesheet recorded for #{participant}" unless @cache[participant]
    """Tracked time for #{participant}:
      #{(effort.summary() for effort in @cache[participant]).join '\n'}
    """

  clearFor: (participant) ->


class Effort
  constructor: (@participant, @id) ->

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

  summary: -> "#{@startTime().toDateString()}: #{@id} - #{@duration()}"


(module ?= {}).exports = (robot) ->

  timesheets = new Timesheets robot

  robot.respond /show my time(sheet)?/i, (msg) ->
    msg.send timesheets.retrieve(msg.message.user.id)

  robot.respond /i'm starting (.*)/i, (msg) ->
    effort_id = msg.match[1]
    timesheets.add new Effort(msg.message.user.id, effort_id)
    msg.send "OK, I will track how long you're working on #{effort_id}"

  robot.respond /i'm done with (.*)/i, (msg) ->

(exports ? this).Effort = Effort
(exports ? this).Timesheets = Timesheets

