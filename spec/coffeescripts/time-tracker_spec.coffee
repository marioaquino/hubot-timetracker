describe 'Effort', ->
  beforeEach ->
    @effort = new Effort('mario')

  describe 'initially', ->

    it 'has an involved list', ->
      expect(@effort.name).toEqual ['mario']

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

    it 'reports its final duration once stopped', ->
      @effort.stop()
      expect(@effort.duration()).toEqual '1 minute'


