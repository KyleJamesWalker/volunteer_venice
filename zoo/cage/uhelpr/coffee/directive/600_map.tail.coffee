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
		matches = @$attrs.markers.match /^\s*(.+)\s+for\s+(.+)\s+in\s+(.*)\s+track\s+by\s+(.+)\s*$/
		@$markerOptionsGetter      = @$parse( matches[ 1 ] )
		@$itemSetter               = @$parse( matches[ 2 ] ).assign
		markerCollectionExpression =          matches[ 3 ]
		@$trackByGetter            = @$parse( matches[ 4 ] )

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

		markerItemsByKey = {}

		# Get the new collection of markerItemKeys, handling the markerItems collection the same whether it's an array or an object by constructing an array of keys
		markerItemKeys = new Array()
		if angular.isArray markerItems
			for markerItem in markerItems
				markerItemKeys.push markerItemKey = @getMarkerItemKey markerItem
				markerItemsByKey[ markerItemKey ] = markerItem
		else if angular.isObject markerItems
			for markerItem of markerItems
				markerItemKeys.push markerItemKey = @getMarkerItemKey markerItem
				markerItemsByKey[ markerItemKey ] = markerItem

		currentMarkerKeys = ( key for key, holder of @$currentMarkerHolders )
		oldMarkerKeys     = _.without currentMarkerKeys, markerItemKeys...
		newMarkerKeys     = _.without markerItemKeys, currentMarkerKeys...

		# Destroy all the marker holders no longer in $currentMarkerHolders
		for key in oldMarkerKeys
			@destroyMarkerHolder key

		# Create marker holders for marker items not yet in the $currentMarkerHolders
		for key in newMarkerKeys
			unless @$currentMarkerHolders[ key ]?
				@$currentMarkerHolders[ key ] = @createMarkerHolder markerItemsByKey[ key ]

	getMarkerItemKey: ( markerItem ) =>
		context = {}
		@$itemSetter context, markerItem
		"#{ @$trackByGetter context }"

	destroyMarkerHolder: ( key ) ->
		markerHolder = @$currentMarkerHolders[ key ]
		if markerHolder?
			markerHolder.$scope.$destroy()
			@$q.all( [
				@$q.when( markerHolder.marker     ).then ( ( marker )     -> marker.setMap null ), ( ( rejection ) -> console.log rejection )
				@$q.when( markerHolder.infoWindow ).then ( ( infoWindow ) -> infoWindow.close() ), ( ( rejection ) -> console.log rejection )
			] ).then =>
				root.delete @$currentMarkerHolders, key

	createMarkerHolder: ( markerItem ) ->
		markerHolder =
			markerItem: markerItem
			infoWindow: ( infoWindowDeferred = @$q.defer() ).promise.then ( infoWindow ) -> markerHolder.infoWindow = infoWindow
			$scope    : ( scopeDeferred      = @$q.defer() ).promise.then ( scope      ) -> markerHolder.$scope     = scope
			marker    : ( markerDeferred     = @$q.defer() ).promise.then ( marker     ) -> markerHolder.marker     = marker
		
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

			markerDeferred.resolve @GoogleMapsApi.makeMarker @$scope.map, markerOptions

		markerHolder.marker.then =>
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