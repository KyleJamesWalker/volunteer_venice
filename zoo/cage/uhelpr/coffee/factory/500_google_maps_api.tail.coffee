root = window

root.$_googleMapsApiLoaded = ->
	root.$_googleMapsApiFactory.$rootScope.$apply -> root.$_googleMapsApiFactory.mapsApiLoaded window.google.maps

root.$_googleMapsApiFactory = null

root.GoogleMapsApi = class GoogleMapsApi extends root.BaseFactory
	$_name: 'GoogleMapsApi'

	$_dependencies: [ '$injector', '$q', '$rootScope', '$timeout' ]

	maxRetries: 3
	retry     : 0

	loaded: no

	constructor: ->
		super

		@$_stats = new root.Stats @$injector

		@mapsApiLoadedDeferred = @$q.defer()
		@mapsApiLoadedPromise = @mapsApiLoadedDeferred.promise

		@loadMapsApi()

		root.$_googleMapsApiFactory = @

	loadMapsApi: =>
		unless @loaded
			yepnope load: "#{ root.defaultScheme }maps.googleapis.com/maps/api/js?key=#{ root.googleApiKey }&sensor=true&callback=$_googleMapsApiLoaded"

	mapsApiLoaded: ( mapsApi ) =>
		@mapsApi = mapsApi if mapsApi?

		@loaded = yes
		@mapsApiLoadedDeferred.resolve "Google API loaded"

root.addFactory GoogleMapsApi
