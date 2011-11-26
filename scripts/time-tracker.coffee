# Track time spent on stories by devs
#
# i am starting on <story number>
# i am done with <story number>
# show my timesheet
module.exports = (robot) ->
  robot.respond /show my time(sheet)?/i, (msg) ->

  robot.respond /i am starting on (\d+)/i, (msg) ->

    #msg.message.user.

  robot.respond /i am done with (\d+)/i, (msg) ->


