root = window

root.S3UploadUrls = class S3UploadUrls extends root.BaseResource

	$_propertyToJsonMapping:
		signedUrl: 'signed_request'
		publicUrl: 'url'

	constructor: (
		@signedUrl = ''
		@publicUrl = ''
	) -> super

	$_fromJson: ->
		target = super
		target.signedUrl = target.signedUrl.replace /\+/g, '%2B'
		target