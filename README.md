# Aadhar Address Update 
### Theme 1 Problem Statement 2


Flow of the application

-Mobile Operator enters using the id/pin code
(Currently any pincode of digits >= 4 will work)

-Scans the document

-The document is scanned for text. Using google's machine learning and vision kit.

-Recognised text is isolated into a separate list of words

-Location is obtained using on board GPS

-Its converted into a street address(reverse geocodding) using a geocode API.

-The street address obtained is referenced against the recognised text to get the potential address.

-Keywords such as "address" are checked from the document. If such text is recognised then the upcoming words are added into the potential address.

-All address key words matched between the text from document and the street address from GPS are put up in the final form of address.

-The user adds the missing fields.

-The address is validated by first converting it into latitude and longitude and meauring the distance from the location of the device.
