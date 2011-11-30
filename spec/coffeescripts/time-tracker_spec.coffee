describe 'Effort', ->
  beforeEach ->
    @effort = new Effort('mario', '1234')

  context 'initially', ->

    it 'has an involved person', ->
      expect(@effort.name).toEqual 'mario'

    it 'has an identifier', ->
      expect(@effort.id).toEqual '1234'

    it 'has an initial duration of zero', ->
      expect(@effort.duration()).toEqual '0 minutes'

  context 'when tracking', ->
    beforeEach ->
      @effort.start()
      currentTime = new Date
      pastTime = new Date(currentTime)
      pastTime.setMinutes(pastTime.getMinutes() - 1)
      spyOn(@effort, 'startTime').andReturn(pastTime)
      spyOn(@effort, 'endTime').andReturn(currentTime)

    it 'reports the elapsed duration relative to the start date', ->
      expect(@effort.duration()).toEqual '1 minute (*)'

    it 'indicates if the effort is running', ->
      expect(@effort.isRunning()).toEqual true

    it 'reports its final duration once stopped', ->
      @effort.stop()
      expect(@effort.duration()).toEqual '1 minute'

  context 'duration reporting', ->
    beforeEach ->
      @effort.start()
      startTime = new Date
      startTime.setHours(2)
      startTime.setMinutes(0)
      endTime = new Date(startTime)
      endTime.setHours(4)
      endTime.setMinutes(45)
      spyOn(@effort, 'startTime').andReturn(startTime)
      spyOn(@effort, 'endTime').andReturn(endTime)

    it 'displays multi-hour durations', ->
      @effort.stop()
      expect(@effort.duration()).toEqual '2 hours and 45 minutes'

  context 'summary', ->
    beforeEach ->
      spyOn(@effort, 'startTime').andReturn(new Date('1/1/2011'))
      spyOn(@effort, 'duration').andReturn('1 hour')

    it 'includes the date of effort, the identifier, and the duration', ->
      expect(@effort.summary()).toEqual('Sat Jan 01 2011: 1234 - 1 hour')


describe 'Timesheets', ->
  beforeEach ->
    @mockRobot =
      onCache: []
      brain:
        on: (eventName, callback) =>
          @mockRobot.onCache.push eventName
    @timesheets = new Timesheets(@mockRobot)

  context 'during initialization', ->
    it 'registers with an on-load event handler', ->
      expect(@mockRobot.onCache[0]).toEqual 'loaded'

  context 'when no efforts are recorded', ->
    it 'says it has no time recorded for you', ->
      expect(@timesheets.retrieve('mario')).toEqual 'I have no timesheet recorded for mario'


