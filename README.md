### Starting Sync Gateway

First start the Couchbase Server. If its not installed then download and install it. 

Then start the sync gateway with (assuming you downloaded it).

$ <sync-gateway-bin-folder>/sync_gateway <location-of-project>/sync-gateway-config.json

Admin call to add a channel to a user

$ curl -X PUT 192.168.1.6:4985/default/_user/ypsslsl_panditescu_1416990118@tfbnw.net --data '{"admin_channels": ["ypsslsl_panditescu_1416990118@tfbnw.net"]}'.
