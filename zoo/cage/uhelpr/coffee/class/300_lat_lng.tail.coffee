root = window

toRad = ( number ) -> number * Math.PI / 180

root.LatLng = class LatLng extends root.BaseResource

	$_propertyToJsonMapping:
		lat: 'lat'
		lng: 'lng'

	constructor: (
		@lat = null
		@lng = null
	) -> super

	$_init: ->
		super
		@id = "#{ @lat },#{ @lng }"

	set: ( @lat, @lng ) ->
		if angular.isFunction( @lat.lat ) and angular.isFunction( @lat.lng )
			[ @lat, @lng ] = [ @lat.lat(), @lat.lng() ]

		@$_init()

	copy: ->
		new @constructor @lat, @lng

	isSame: ( latLng ) ->
		( @lat is latLng.lat() and @lng is latLng.lng() ) or
		@distanceTo( latLng ) < .01 # within 10 meters

	lat: -> @lat
	lng: -> @lng

	# using the Spherical cosine law
	distanceTo: ( latLng, inRadians ) ->
		R = 6371 # km
		lat1 = toRad @lat         unless inRadians
		lng1 = toRad @lng         unless inRadians
		lat2 = toRad latLng.lat() unless inRadians
		lng2 = toRad latLng.lng() unless inRadians

		Math.acos( Math.sin( lat1 ) * Math.sin( lat2 ) + 
		           Math.cos( lat1 ) * Math.cos( lat2 ) * 
		           Math.cos( lng2 - lng1 ) ) * R;