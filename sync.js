function(doc, oldDoc) {
	requireUser(doc.owner);
	if (oldDoc != null) {
        if (doc.owner != oldDoc.owner) {
            throw(forbidden: "Can't change owner");
       	}
    }
    requireAccess(doc.channels);
	channel(doc.channels);
}