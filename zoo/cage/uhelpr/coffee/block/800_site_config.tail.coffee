root = window

root.SiteConfig = class SiteConfig extends root.ConfigBlock

	$_dependencies: [ '$urlRouterProvider' ]

	setupStates: ->
		super

		@$urlRouterProvider.otherwise '/organizations'

		@addState 'site',
			templateUrl: "site.html"
			controller : root.Site

		@addState 'organizations',
			parent     : 'site'
			url        : "^/organizations"
			templateUrl: "organizations.html"
			controller : root.Organizations

	setupInterceptors: ->
		@addHighestPrecedenceInterceptor root.CommunicationInterceptor::$_makeName()

root.addConfigBlock SiteConfig
