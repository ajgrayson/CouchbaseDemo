function(doc, oldDoc) {
	requireUser(doc.owner);
	if (oldDoc != null) {
        if (doc.owner != oldDoc.owner) {
            throw({forbidden: 'Cant change owner'});
       	}
    }
    requireAccess(doc.channels);
	channel(doc.channels);
}


function(doc, oldDoc) {
	if (oldDoc != null) {
        if (doc.owner != oldDoc.owner) {
            throw({forbidden: 'Cant change owner'});
       	}
    }

    if(oldDoc != null) {
    	requireAccess('ch-' + oldDoc.owner);
	} else {
		requireAccess('ch-' + doc.owner);
	}
	channel('ch-' + doc.owner);
}