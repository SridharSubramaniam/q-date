describe "qDateUtil", ->
  qDateUtil = null
  beforeEach(angular.mock.module('q-date'))
  beforeEach(inject((_qDateUtil_) ->
    qDateUtil = _qDateUtil_
    return
  ))

  describe 'isDateObject()', ->
    it 'should be true for a new date', ->
      expect(qDateUtil.isDateObject(new Date())).toBeTruthy()
    it 'should be false for a string', ->
      expect(qDateUtil.isDateObject("1/1/2014")).toBeFalsy()

  describe 'incrementMonth()', ->
    it 'should increment by 1 properly', ->
      d = new Date(2014, 3, 15)
      expect(d.getMonth()).toEqual(3)
      expect(qDateUtil.incrementMonth(d, 1).getMonth()).toEqual(4)
      d = new Date(2014, 11, 15)
      result = qDateUtil.incrementMonth(d, 1) 
      expect(result.getMonth()).toEqual(0)
      expect(result.getFullYear()).toEqual(2015)

    it 'should increment by -1 properly', ->
      d = new Date(2014, 3, 15)
      expect(d.getMonth()).toEqual(3)
      expect(qDateUtil.incrementMonth(d, -1).getMonth()).toEqual(2)
      d = new Date(2014, 0, 15)
      result = qDateUtil.incrementMonth(d, -1) 
      expect(result.getMonth()).toEqual(11)
      expect(result.getFullYear()).toEqual(2013)

    it 'should increment by 2 properly', ->
      d = new Date(2014, 3, 15)
      expect(d.getMonth()).toEqual(3)
      expect(qDateUtil.incrementMonth(d, 2).getMonth()).toEqual(5)
      d = new Date(2014, 10, 15)
      result = qDateUtil.incrementMonth(d, 2) 
      expect(result.getMonth()).toEqual(0)
      expect(result.getFullYear()).toEqual(2015)

    xit 'should factor in different days in the months', ->
      d = new Date(2014, 2, 30)
      r = qDateUtil.incrementMonth(d, -1)
      console.log r
      expect(r.getMonth()).toEqual(1)
      expect(r.getDate()).toEqual(28)
