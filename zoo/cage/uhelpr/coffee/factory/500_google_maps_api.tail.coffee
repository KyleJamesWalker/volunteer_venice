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

		@$loadedDeferred = @$q.defer()
		@$loadedPromise = @$loadedDeferred.promise

		@loadMapsApi()

		root.$_googleMapsApiFactory = @

	getAllPendingResults: ->
		@$loadedPromise

	loadMapsApi: =>
		unless @isLoaded
			yepnope load: "#{ root.defaultScheme }maps.googleapis.com/maps/api/js?key=#{ root.googleApiKey }&sensor=true&callback=$_googleMapsApiLoaded"

	loaded: ( api ) =>
		@api = api if api?

		@isLoaded = yes
		@$loadedDeferred.resolve "Google API loaded"

	makeMap: ( element, options ) ->
		@$loadedPromise.then =>

			defaultOptions =
				center   : new @api.LatLng(-34.397, 150.644)
				zoom     : 14
				mapTypeId: @api.MapTypeId.ROADMAP
				
			options = angular.extend {}, defaultOptions, options

			new @api.Map element, options

	panMapTo: ( map, position ) ->
		position = position.copy()
		@$loadedPromise.then =>
			@$q.when( map ).then ( map ) =>
				center = map.getCenter()
				newCenter = new @api.LatLng position.lat, position.lng
				map.panTo newCenter unless newCenter.equals center

	addListener: ( target, eventName, callback ) ->
		@$loadedPromise.then =>
			@$q.when( target ).then ( target ) =>
				@api.event.addListener target, eventName, callback

	makeMarker: ( map, markerOptions = {} ) ->
		deferredMarker = @$q.defer()

		@$loadedPromise.then(
			=>
				@$q.when( map ).then ( map ) =>

					# Allow the markerOptions itself and any field of the markerOptions to be a promise that will have to be resolved before making the marker with the markerOptions
					@$q.when( markerOptions ).then ( markerOptions ) =>
						@$q.all( @$q.when value for key, value of markerOptions ).then =>

							defaultMarkerOptions = { map: map }

							if markerOptions.position instanceof root.LatLng
								defaultMarkerOptions.position = new @api.LatLng(
									markerOptions.position.lat
									markerOptions.position.lng
								)

							angular.extend defaultMarkerOptions, markerOptions

							deferredMarker.resolve new @api.Marker defaultMarkerOptions

		).then null, -> deferredMarker.reject()

		deferredMarker.promise

	makeInfoWindow: ( content, infoWindowOptions = {} ) ->
		deferredInfoWindow = @$q.defer()

		@$loadedPromise.then(
			=>
				# Allow the infoWindowOptions itself and any field of the infoWindowOptions to be a promise that will have to be resolved before making the marker with the infoWindowOptions
				@$q.when( infoWindowOptions ).then ( infoWindowOptions ) =>
					@$q.all( @$q.when value for key, value of infoWindowOptions ).then =>

						defaultInfoWindowOptions = { content: content }

						if infoWindowOptions.position instanceof root.LatLng
							defaultInfoWindowOptions.position = new @api.LatLng(
								infoWindowOptions.position.lat
								infoWindowOptions.position.lng
							)

						angular.extend defaultInfoWindowOptions, infoWindowOptions

						deferredInfoWindow.resolve new @api.InfoWindow defaultInfoWindowOptions

		).then null, -> deferredInfoWindow.reject()

		deferredInfoWindow.promise

	geocodeAddress: ( address, nearLatLng ) ->
		deferredGeocoderResults = @$q.defer()

		nearLatLng = nearLatLng.copy()

		@$loadedPromise.then(
			=>
				@geocoder = new @api.Geocoder() unless @geocoder?

				geocoderRequest          = {}
				geocoderRequest.address  = address
				geocoderRequest.location = new @api.LatLng nearLatLng.lat, nearLatLng.lng

				@geocoder.geocode geocoderRequest, ( geocoderResults, geocoderStatus ) =>
					if geocoderStatus is @api.GeocoderStatus.OK
						deferredGeocoderResults.resolve geocoderResults
					else
						deferredGeocoderResults.reject()

		).then null, -> deferredGeocoderResults.reject()

		deferredGeocoderResults.promise

root.addFactory GoogleMapsApi
