root = window

lastMarkerId = -1

class MapController extends root.BaseDirectiveController
	$_name: 'MapController'

	$_dependencies: [ root.GoogleMapsApi, '$q', '$parse' ]

	constructor: ->
		super

		# Makes the map
		@$scope.map = @GoogleMapsApi.makeMap( @$element[ 0 ], disableDefaultUI: yes ).then ( map ) => @$scope.map = map

		# Listens to the maps pan event to set our scope's centerLatLng
		@GoogleMapsApi.addListener @$scope.map, 'center_changed', _.throttle ( => @$scope.$apply @mapMoved ), 500

		# Listens to our scope's centerLatLng to pan the map to that location
		@$scope.$watch 'centerLatLng', @centerChanged, yes

		# parse out the pieces of the markerItems attribute of the form '_marker_options_expression_ for _item_expression_ in _collection_'
		matches = @$attrs.markers.match /^\s*(.+)\s+for\s+(.+)\s+in\s+(.*)\s*$/
		@$markerOptionsGetter      = @$parse( matches[ 1 ] )
		@$itemSetter               = @$parse( matches[ 2 ] ).assign
		markerCollectionExpression = matches[ 3 ]

		@$scope.$parent.$watchCollection markerCollectionExpression, @markerItemsChanged

		# Initializes our scope's centerLatLng
		@$scope.map.then @mapMoved

	centerChanged: ( newLatLng ) =>
		@GoogleMapsApi.panMapTo @$scope.map, newLatLng if newLatLng? and not newLatLng.isSame @$scope.map.getCenter()

	mapMoved: =>
		# initializes our scope's centerLatLng unless it is already
		@$scope.centerLatLng = new root.LatLng() unless @$scope.centerLatLng?

		# updates our scope's centerLatLng (by updating its values, so as to do so without orphaning its current instance)
		@$scope.centerLatLng.set @$scope.map.getCenter()

	markerItemsChanged: ( markerItems ) =>
		# initialize the collection of marker holders if it doesn't already exist
		@$currentMarkerHolders = {} unless @$currentMarkerHolders?

		# Get the collection of marker holders no longer in the markerItems collection
		oldMarkerHolders = {}
		for key, marker of @$currentMarkerHolders
			oldMarkerHolders[ key ] = marker if not @$currentMarkerHolders[ key ]?

		# Destroy all the marker holders no longer in $currentMarkerHolders
		for key, oldMarkerHolder of oldMarkerHolders
			@destroyMarkerHolder oldMarkerHolder

		# Handle the markerItems collection the same whether it's an array or an object by constructing an array of keys
		markerItemKeys = new Array()
		if angular.isArray markerItems
			markerItemKeys.push [ 0 .. markerItems.length - 1 ]...
		else if angular.isObject markerItems
			( markerItemKeys.push key unless /^\$/.test key ) for key in _.keys markerItems

		# Create marker holders for marker items not yet in the $currentMarkerHolders
		for key in markerItemKeys
			@$currentMarkerHolders[ key ] = @createMarkerHolder markerItems[ key ] unless @$currentMarkerHolders[ key ]?

	destroyMarkerHolder: ( markerHolder ) ->
		markerHolder.infoWindow.close()
		@$q.when( markerHolder.marker ).then ( marker ) -> marker.setMap null
		markerHolder.$scope.$destroy()

	createMarkerHolder: ( markerItem ) ->
		markerHolder =
			$scope    : null
			marker    : null
			infoWindow: null

		markerHolder.infoWindow = ( infoWindowDeferred = @$q.defer() ).promise.then ( infoWindow ) -> markerHolder.infoWindow = infoWindow

		markerHolder.$scope = ( scopeDeferred = @$q.defer() ).promise.then ( scope ) -> markerHolder.$scope = scope
		
		# create an infoWindow using the transcluded element clone transcluded with the new markerItem scope
		@$transclude ( $elementClone, scope ) =>
			scopeDeferred.resolve scope
			infoWindowDeferred.resolve @GoogleMapsApi.makeInfoWindow $elementClone[ 0 ]

		# create the new child scope for the markerItem from this directive's scope's parent (since it's an isolate scope)
		markerHolder.$scope.then =>
			# assign onto the new markerItem scope the item expression
			@$itemSetter markerHolder.$scope, markerItem

			# get from the new markerItem scope the marker options object using the marker options expression
			markerOptions = @$markerOptionsGetter markerHolder.$scope

			# create the marker and add it to the map using the marker options object
			markerHolder.marker = @GoogleMapsApi.makeMarker( @$scope.map, markerOptions ).then ( marker ) =>
				markerHolder.marker = marker

				# hook up the infoWindow's creation and displaying to the marker's click event
				@GoogleMapsApi.addListener markerHolder.marker, 'click', =>
					# then when the current infoWindow has been created
					@$q.when( markerHolder.infoWindow ).then =>
						# if another infoWindow is already open, close it
						if @$lastOpenedInfoWindow?
							@$lastOpenedInfoWindow.close()

						# open it
						markerHolder.infoWindow.open @$scope.map, markerHolder.marker

						# and set it to the last opened infoWindow
						@$lastOpenedInfoWindow = markerHolder.infoWindow

		markerHolder

class Map extends root.BaseDirective
	$_name: 'Map'

	restrict: 'E'

	controller: MapController

	transclude: yes

	scope:
		map          : '='
		centerLatLng : '='

root.addDirective Map