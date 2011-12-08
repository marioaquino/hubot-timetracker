describe 'Effort', ->
  beforeEach ->
    @effort = new Effort('mario', '1234')

  context 'initially', ->

    it 'has an involved person', ->
      expect(@effort.participant).toEqual 'mario'

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

    it 'reports the elapsed duration relative to the start date', ->
      expect(@effort.duration()).toEqual '1 minute (*)'

    it 'indicates if the effort is running', ->
      expect(@effort.isRunning()).toBe true

    it 'reports its final duration once stopped', ->
      @effort.stop()
      expect(@effort.duration()).toEqual '1 minute'

  context 'stopping', ->
    it 'can only be be done when an effort is running',  ->
      spyOn(@effort, 'isRunning').andReturn(false)
      @effort.stop()
      expect(@effort.endTime()).toBeUndefined()

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
        on: (eventparticipant, callback) =>
          @mockRobot.onCache.push eventparticipant
    @timesheets = new Timesheets(@mockRobot)

  context 'during initialization', ->
    it 'registers with an on-load event handler', ->
      expect(@mockRobot.onCache[0]).toEqual 'loaded'

  context 'when no efforts are recorded', ->
    it 'says it has no time recorded for you', ->
      expect(@timesheets.retrieve('mario')).toEqual 'I have no timesheet recorded for mario'

    it 'clearing the timesheet has no effect', ->
      @timesheets.clearFor('mario')
      expect(@timesheets.retrieve('mario')).toEqual 'I have no timesheet recorded for mario'

  context 'persisting the timesheet cache', ->
    it 'sends the cache to the robot for storage', ->
      brainSpy = jasmine.createSpy()
      @mockRobot.brain = brainSpy
      dataSpy = jasmine.createSpy()
      brainSpy.data = dataSpy
      @timesheets.cache = 'foo'

      @timesheets.persistCache()

      expect(dataSpy.timesheets).toEqual('foo')

  context 'starting efforts', ->
    beforeEach ->
      @effort = { participant: 'mario', id: '1234', start: ->}
      spyOn(@effort, 'start')
      spyOn(@timesheets, 'persistCache')
      @timesheets.startEffort @effort

    it 'starts the effort', ->
      expect(@effort.start).toHaveBeenCalled()

    it 'stores the cache in the robot', ->
      expect(@timesheets.persistCache).toHaveBeenCalled()

  context 'stopping efforts', ->
    context 'that exist', ->
      beforeEach ->
        @effort = { participant: 'mario', id: '1234', stop: ->}
        spyOn(@effort, 'stop')
        spyOn(@timesheets, 'persistCache')
        @timesheets.cache['mario'] = {'1234':  [@effort] }

        @returnValue = @timesheets.stopEffort 'mario', '1234'

      it 'stops a running effort', ->
        expect(@effort.stop).toHaveBeenCalled()

      it 'tells you the effort has been stopped', ->
        expect(@returnValue).toEqual('Hey everybody! mario stopped working on 1234')

      it 'stores the cache in the robot', ->
        expect(@timesheets.persistCache).toHaveBeenCalled()

    context 'that do not exist', ->
      it 'tells you that it doesnt know the effort you told it to stop', ->
        expect(@timesheets.stopEffort('mario', '1234')).toEqual('Oops, mario tried to stop 1234 but never started it')

  context 'when efforts are recorded', ->
    beforeEach ->
      brainSpy = jasmine.createSpy()
      @mockRobot.brain = brainSpy
      brainSpy.data = jasmine.createSpy()

      @timesheets.startEffort
        participant: 'mario'
        summary: -> 'Sat Jan 01 2011: 12345 - 2 hours and 30 minutes'
        start: ->

      @timesheets.startEffort
        participant: 'mario'
        summary: -> 'Sat Jan 01 2011: 54321 - 1 hour'
        start: ->

    it 'includes them in the timesheet', ->
      expect(@timesheets.retrieve('mario')).toEqual '''Tracked time for mario:
        Sat Jan 01 2011: 12345 - 2 hours and 30 minutes
        Sat Jan 01 2011: 54321 - 1 hour'''

    context 'clearing the timesheet', ->
      beforeEach ->
        spyOn(@timesheets, 'persistCache')
        @timesheets.clearFor('mario')

      it 'removes all efforts for a given participant', ->
        expect(@timesheets.retrieve('mario')).toEqual 'I have no timesheet recorded for mario'

      it 'stores the cache in the robot', ->
        expect(@timesheets.persistCache).toHaveBeenCalled()

