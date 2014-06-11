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

  describe 'getHoursMinutes()', ->
    it 'works with 24-hour format', ->
      expect(qDateUtil.getHoursMinutes(new Date(2014, 6, 15, 17, 22), false)).toEqual([17, 22])
      expect(qDateUtil.getHoursMinutes(new Date(2014, 6, 15, 3, 0), false)).toEqual([3, 0])
      expect(qDateUtil.getHoursMinutes(new Date(2014, 6, 15, 23, 59), false)).toEqual([23, 59])
      expect(qDateUtil.getHoursMinutes(new Date(2014, 6, 15, 0, 0), false)).toEqual([0, 0])
    it 'works with 12-hour format', ->
      expect(qDateUtil.getHoursMinutes(new Date(2014, 6, 15, 17, 22), true)).toEqual([5, 22, 'pm'])
      expect(qDateUtil.getHoursMinutes(new Date(2014, 6, 15, 3, 0), true)).toEqual([3, 0, 'am'])
      expect(qDateUtil.getHoursMinutes(new Date(2014, 6, 15, 23, 59), true)).toEqual([11, 59, 'pm'])
      expect(qDateUtil.getHoursMinutes(new Date(2014, 6, 15, 0, 0), true)).toEqual([12, 0, 'am'])
