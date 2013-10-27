root = window

# Where callback = function( year, month, day, dayMoment ) is called for each day where moment is the startOf( 'day' ) moment for each day in the given moment range.
root.forEachDay = ( fromMoment, toMoment, callback ) ->
	fromYear  = moment( fromMoment ).year()
	toYear    = moment( toMoment   ).year()
	fromMonth = moment( fromMoment ).month()
	toMonth   = moment( toMoment   ).month()
	fromDay   = moment( fromMoment ).date()
	toDay     = moment( toMoment   ).date()

	for year in [ fromYear .. toYear ]
		yearMoment = moment [ year ]
		firstMonth = if year is fromYear then fromMonth else moment( yearMoment ).startOf( 'year' ).month()
		lastMonth  = if year is toYear   then toMonth   else moment( yearMoment ).endOf(   'year' ).month()

		for month in [ firstMonth .. lastMonth ]
			monthMoment = moment [ year, month ]
			firstDay = if month is fromMonth then fromDay else moment( monthMoment ).startOf( 'month' ).date()
			lastDay  = if month is toMonth   then toDay   else moment( monthMoment ).endOf(   'month' ).date()
			for day in [ firstDay .. lastDay ]
				callback year, month, day, moment [ year, month, day ]

root.getDateKey = ( date ) ->
	return null unless date?

	dateMoment = moment date
	if dateMoment?.isValid()
		dateMoment.local().startOf( 'day' ).toISOString()
	else
		throw new TypeError "#{ date } is not a valid date."

root.toServerDateString = root.getDateKey

root.fromServerDateString = ( dateString ) ->
	return null unless dateString?.length

	if ( date = moment( dateString ) )?.isValid()
		date.local()
	else
		throw new TypeError "#{ dateString } is not a valid UTC date."