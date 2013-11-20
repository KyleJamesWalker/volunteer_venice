root = window

lastOrganizationId = 0

root.Organization = class Organization extends root.UhelprResource

	$_propertyToJsonMapping:
		address    : 'address' # "501 S. Venice Blvd.",
		categoryId : 'category_id' # "Arts and Education",
		description: 'description' # "",
		email      : 'email' # "",
		id         : 'id' # 1,
		location   : 'location' # null,
		name       : 'name' # "Abbot Kinney Memorial Library",
		phoneNumber: 'phone_number' # "310.821.1769",
		image      : 'picture_location' # "",
		video      : 'video_location' # "",
		website    : 'website' # "http://www.lapl.org/branches/venice"

	constructor: (
		@address     = null # '501 S. Venice Blvd.' # 
		@categoryId  = null # 'Arts and Education' # 
		@description = null # '' # 
		@email       = null # '' # 
		@id          = null # lastOrganizationId++ # 
		@location    = null # null # 
		@name        = null # "Abbot Kinney Memorial Library (Fake \##{ lastOrganizationId })" # 
		@phoneNumber = null # '310.821.1769' # 
		@image       = null # '' # 
		@video       = null # '' # 
		@website     = null # 'http://www.lapl.org/branches/venice' # 
	) -> super

	$_initNonJsonMembers: ->
		@image = "#{ root.imgPath }#{ _.random( 1, 8 ) }.jpg" unless @image?.length > 0