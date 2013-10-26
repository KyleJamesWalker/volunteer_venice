root = window

root.BaseS3UploadUrlsRequester = class BaseS3UploadUrlsRequester extends root.BaseResourceRequester

	$_resourceClass: root.S3UploadUrls

	$_apiDomain: root.apiDomain

	$_actions:
		get:
			method: 'GET'

	getUrlsFor: ( file ) => throw new Error "This must be overridden in your actual S3 URL requester."