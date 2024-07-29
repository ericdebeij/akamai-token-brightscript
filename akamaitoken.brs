function GetEpochTime() as Integer
	dt = CreateObject("roDateTime")
	return dt.AsSeconds()	
end function

function AkamaiToken(tokenName as String, keyHex as String, startTime as Integer, window as Integer, acl as String, payload as String) as String
	
	endtime = starttime + window
	stringToSign = "st=" + startTime.tostr() + "~exp=" + endtime.tostr() + "~acl=" + acl
	if payload <> "" then	
		stringToSign = stringToSign + "~data=" + payload
	end if
	sha256 = CreateObject("roHMAC")
	bakey = CreateObject("roByteArray")
	bamsg = CreateObject("roByteArray")
	bakey.FromHexString(keyHex)
	bamsg.FromAsciiString(stringToSign)
	if sha256.Setup("sha256",bakey) = 0 then
	   hash = LCase(sha256.Process(bamsg).ToHexString())
	   return tokenname + "=" + stringToSign + "~hmac=" + hash
	else
	   return "Failure"
	end if
end function

REM Example values
keyHex = "aabbccddeeff00112233445566778899"
startTime = GetEpochTime()
window = 60
acl = "/*"
payload = "abc"

REM create the token
token = AkamaiToken("hdnts", keyHex, startTime, window, acl, payload)
print(token)

REM Test with hardcoded epochtime
token = AkamaiToken("hdnts", keyHex, 1722248530, window, acl, payload)
print(token)
