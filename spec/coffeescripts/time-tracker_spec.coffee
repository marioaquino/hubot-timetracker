describe 'Effort', ->
  beforeEach ->
    @effort = new Effort('mario', '1234')

  describe 'initially', ->

    it 'has an involved person', ->
      expect(@effort.name).toEqual 'mario'

    it 'has an identifier', ->
      expect(@effort.id).toEqual '1234'

    it 'has an initial duration of zero', ->
      expect(@effort.duration()).toEqual '0 minutes'

  describe 'when tracking', ->
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


