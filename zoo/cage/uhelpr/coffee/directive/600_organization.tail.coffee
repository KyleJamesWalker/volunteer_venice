root = window

class OrganizationController extends root.BaseDirectiveController
	$_name: 'OrganizationController'

	constructor: ->
		super

		@imageClass = 'button-shadow slow transitions': yes

		@$scope.$watch 'organization.selected', ( selected ) =>
			@imageClass[ 'whole-rounded' ] = ! selected
			@imageClass[ 't-rounded'     ] = selected

	preventDefault: ( $event ) ->
		$event.stopPropagation()

class Organization extends root.BaseTemplatedDirective
	$_name: 'Organization'

	controller: OrganizationController

	scope:
		organization     : '='
		onMapOrganization: '&'

root.addDirective Organization