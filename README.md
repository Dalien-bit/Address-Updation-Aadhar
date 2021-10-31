# Aadhar Address Update 
### Theme 1 Problem Statement 2

Flow of the application

-Mobile Operator enters using the id/pin code
(Currently any pincode of digits >= 4 will work)<br/>
-Scans the document<br/>
-The document is scanned for text. Using google's machine learning and vision kit.<br/>
-Recognised text is isolated into a separate list of words<br/>
-Location is obtained using on board GPS<br/>
-Its converted into a street address(reverse geocodding) using a geocode API.<br/>
-The street address obtained is referenced against the recognised text to get the potential address.<br/>
-Keywords such as "address" are checked from the document. If such text is recognised then the upcoming words are added into the potential address.<br/>
-All address key words matched between the text from document and the street address from GPS are put up in the final form of address.<br/>
-The user adds the missing fields.<br/>
-The address is validated by first converting it into latitude and longitude and meauring the distance from the location of the device.<br/>
-If the distance radius is under 500m the process is completed.<br/>
-All the documents and address variables are now converted into a JSON object to be uploaded to the UIDAI servers for final verification.

Tech Used - Flutter and Dart SDK

#### Some points to keep in mind
-Most of the opensource geocoding APIs are farely inaccurate in rural areas. In urban areas they work fine. So the theshold has been set to 1KM and is referneced against the street address.<br/>
-Each geocoding APIs follow a different address format i.e. they refer to different landmarks than the ones present in the address proof. This issue is resolved by taking account of both the landmarks provided by the geocode and the address proof.<br/>
-The text recognition might not get all the words in first try so we can scan the documnet multiple times.<br/>
-The image scanned is converted to a base64 string for storing it in the JSON body.
-The JSON object is not stored locally as this might be a potential harm cause the files can be modified.
