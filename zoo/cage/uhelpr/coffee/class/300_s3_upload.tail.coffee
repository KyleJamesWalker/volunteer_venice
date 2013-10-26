root = window

# S3 CORS upload

# http://docs.amazonwebservices.com/AmazonS3/latest/dev/cors.html#how-do-i-enable-cors
# http://www.ioncannon.net/programming/1539/direct-browser-uploading-amazon-s3-cors-fileapi-xhr2-and-signed-puts/
# https://github.com/carsonmcdonald/direct-browser-s3-upload-example

lastId = 0

root.S3Upload = class S3Upload

	urlRequestDeferred: null
	urlRequestPromise : null

	constructor: (
		@file
		@S3UploadUrlsRequester
		@$scope
		@$q
		@progress = 0
		@message  = 'Waiting to upload'
		@id       = ++lastId
	) ->
		@deferred = null

	startUpload: =>
		@deferred.reject "Another upload started." if @deferred?

		@deferred = @$q.defer()

		@notify "Upload started.", 0

		@uploadFile()

		@deferred.promise

	uploadFile: =>
		@S3UploadUrlsRequester.getUrlsFor( @file ).$_promise.then(
			# resolve callback
			( s3UploadUrls ) => @uploadToS3 s3UploadUrls

			# reject callback
			=> @reject "Couldn't get the signed S3 upload target."
		)

	# Use a CORS call to upload the given file to S3. Assumes the url
	# parameter has been signed and is accessible for upload.
	uploadToS3: ( s3UploadUrls ) =>
		@xhr = @createCORSRequest 'PUT', s3UploadUrls.signedUrl
		if !@xhr
			@reject 'Could not upload to S3 because CORS is not supported on your browser.'
		else
			@xhr.onload = => @$scope.$apply =>
				if @xhr.status >= 200 and @xhr.status < 300
					@notify 'Upload complete', 100
					@resolve s3UploadUrls.publicUrl
				else
					@reject 'Upload to S3 failed'

			@xhr.onerror = => @$scope.$apply =>
				@reject 'XHR error.'

			@xhr.upload.onprogress = ( e ) => @$scope.$apply =>
				if e.lengthComputable
					percentLoaded = Math.round ( e.loaded / e.total ) * 100
					@notify ( if percentLoaded is 100 then 'Upload finishing.' else 'Uploading.' ), percentLoaded

		@xhr.setRequestHeader 'Content-Type', @file.type
		@xhr.setRequestHeader 'x-amz-acl', 'public-read'

		@notify "Beginning upload.", 0

		@xhr.send @file

	notify: ( message, progress = 0 ) =>
		@progress = progress
		@message = message
		@message  = "#{ @progress }% #{ @message }" if @progress > 0
		@deferred.notify @message

	reject: ( message ) =>
		@message = message
		@deferred.reject message
		@deferred = null

	resolve: ( publicUrl ) =>
		@message = "Upload successful"
		@deferred.resolve publicUrl
		@deferred = null

	createCORSRequest: ( method, url ) =>
		xhr = new XMLHttpRequest()
		if xhr.withCredentials?
			xhr.open method, url, true
		else if typeof XDomainRequest isnt "undefined"
			xhr = new XDomainRequest()
			xhr.open method, url
		else
			xhr = null
		xhr

root.addFactory S3Upload