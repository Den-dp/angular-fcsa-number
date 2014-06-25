describe 'fcsaNumber', ->
  form = undefined
  $scope = undefined
  $compile = undefined

  beforeEach module 'fcsa-number'
  beforeEach inject(($rootScope, _$compile_) ->
    $scope = $rootScope
    $compile = _$compile_
    $scope.model = { number: 0 }
  )

  compileForm = (options = '{}') ->
    $compile("<form name='form'><input type='text' name='number' ng-model='model.number' fcsa-number='#{options}' /></form>")($scope)
    $scope.$digest()
    $scope.form

  isValid = (args) ->
    args.options ||= '{}'
    $compile("<form name='form'><input type='text' name='number' ng-model='model.number' fcsa-number='#{args.options}' /></form>")($scope)
    $scope.$digest()
    $scope.form.number.$setViewValue args.val
    $scope.form.number.$valid

  describe 'no options', ->
    it 'validates positive number', ->
      valid = isValid
        val: '1'
      expect(valid).toBe true

    it 'validates negative number', ->
      valid = isValid
        val: '-1'
      expect(valid).toBe true

    it 'validates number with decimals', ->
      valid = isValid
        val: '1.1'
      expect(valid).toBe true

    it 'invalidates number with multiple decimals', ->
      valid = isValid
        val: '1.1.2'
      expect(valid).toBe false

    it 'invalidates non number', ->
      valid = isValid
        val: '1a'
      expect(valid).toBe false

  describe 'options', ->
    describe 'max', ->
      it 'validates numbers below or equal to max', ->
        valid = isValid
          options: '{ max: 100 }'
          val: '100'
        expect(valid).toBe true

      it 'invalidates numbers above max', ->
        valid = isValid
          options: '{ max: 100 }'
          val: '100.1'
        expect(valid).toBe false

    describe 'min', ->
      it 'validates numbers not below the min', ->
        valid = isValid
          options: '{ min: 0 }'
          val: '0'
        expect(valid).toBe true

      it 'invalidates numbers below the min', ->
        valid = isValid
          options: '{ min: 0 }'
          val: '-0.1'
        expect(valid).toBe false

    describe 'digits', ->
      it 'validates postive numbers not above number of digits', ->
        valid = isValid
          options: '{ digits: 2 }'
          val: '99'
        expect(valid).toBe true

      it 'invalidates postive numbers above number of digits', ->
        valid = isValid
          options: '{ digits: 2 }'
          val: '999'
        expect(valid).toBe false

      it 'validates negative numbers not above number of digits', ->
        valid = isValid
          options: '{ digits: 2 }'
          val: '-99'
        expect(valid).toBe true

    describe 'decimals', ->
      it 'validates numbers without more decimals', ->
        valid = isValid
          options: '{ decimals: 2 }'
          val: '1.23'
        expect(valid).toBe true

      it 'invalidates numbers with more decimals', ->
        valid = isValid
          options: '{ decimals: 2 }'
          val: '1.234'
        expect(valid).toBe false