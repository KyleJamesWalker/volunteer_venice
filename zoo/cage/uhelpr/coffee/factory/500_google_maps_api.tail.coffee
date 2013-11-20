root = window

root.$_googleMapsApiLoaded = ->
	root.$_googleMapsApiFactory.$rootScope.$apply -> root.$_googleMapsApiFactory.loaded window.google.maps

root.$_googleMapsApiFactory = null

root.GoogleMapsApi = class GoogleMapsApi extends root.BaseFactory
	$_name: 'GoogleMapsApi'

	$_dependencies: [ '$injector', '$q', '$rootScope', '$timeout' ]

	maxRetries: 3
	retry     : 0

	isLoaded: no

	constructor: ->
		super

		@$_stats = new root.Stats @$injector

		@loadedDeferred = @$q.defer()
		@loadedPromise = @loadedDeferred.promise

		@loadMapsApi()

		root.$_googleMapsApiFactory = @

	loadMapsApi: =>
		unless @isLoaded
			yepnope load: "#{ root.defaultScheme }maps.googleapis.com/maps/api/js?key=#{ root.googleApiKey }&sensor=true&callback=$_googleMapsApiLoaded"

	loaded: ( api ) =>
		@api = api if api?

		@isLoaded = yes
		@loadedDeferred.resolve "Google API loaded"

	makeMap: ( element, options ) ->
		@loadedPromise.then =>

			defaultOptions =
				center   : new @api.LatLng(-34.397, 150.644)
				zoom     : 8
				mapTypeId: @api.MapTypeId.ROADMAP
				
			options = angular.extend {}, defaultOptions, options

			new @api.Map element, options

root.addFactory GoogleMapsApi
