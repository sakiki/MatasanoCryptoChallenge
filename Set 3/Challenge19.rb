#!/usr/bin/ruby

# Set 3 - Challenge 19
# Break fixed-nonce CTR mode using substitutions

require './set3Lib.rb'

ctArr = Array.new

ctArr << "SSBoYXZlIG1ldCB0aGVtIGF0IGNsb3NlIG9mIGRheQ=="
ctArr << "Q29taW5nIHdpdGggdml2aWQgZmFjZXM="
ctArr << "RnJvbSBjb3VudGVyIG9yIGRlc2sgYW1vbmcgZ3JleQ=="
ctArr << "RWlnaHRlZW50aC1jZW50dXJ5IGhvdXNlcy4="
ctArr << "SSBoYXZlIHBhc3NlZCB3aXRoIGEgbm9kIG9mIHRoZSBoZWFk"
ctArr << "T3IgcG9saXRlIG1lYW5pbmdsZXNzIHdvcmRzLA=="
ctArr << "T3IgaGF2ZSBsaW5nZXJlZCBhd2hpbGUgYW5kIHNhaWQ="
ctArr << "UG9saXRlIG1lYW5pbmdsZXNzIHdvcmRzLA=="
ctArr << "QW5kIHRob3VnaHQgYmVmb3JlIEkgaGFkIGRvbmU="
ctArr << "T2YgYSBtb2NraW5nIHRhbGUgb3IgYSBnaWJl"
ctArr << "VG8gcGxlYXNlIGEgY29tcGFuaW9u"
ctArr << "QXJvdW5kIHRoZSBmaXJlIGF0IHRoZSBjbHViLA=="
ctArr << "QmVpbmcgY2VydGFpbiB0aGF0IHRoZXkgYW5kIEk="
ctArr << "QnV0IGxpdmVkIHdoZXJlIG1vdGxleSBpcyB3b3JuOg=="
ctArr << "QWxsIGNoYW5nZWQsIGNoYW5nZWQgdXR0ZXJseTo="
ctArr << "QSB0ZXJyaWJsZSBiZWF1dHkgaXMgYm9ybi4="
ctArr << "VGhhdCB3b21hbidzIGRheXMgd2VyZSBzcGVudA=="
ctArr << "SW4gaWdub3JhbnQgZ29vZCB3aWxsLA=="
ctArr << "SGVyIG5pZ2h0cyBpbiBhcmd1bWVudA=="
ctArr << "VW50aWwgaGVyIHZvaWNlIGdyZXcgc2hyaWxsLg=="
ctArr << "V2hhdCB2b2ljZSBtb3JlIHN3ZWV0IHRoYW4gaGVycw=="
ctArr << "V2hlbiB5b3VuZyBhbmQgYmVhdXRpZnVsLA=="
ctArr << "U2hlIHJvZGUgdG8gaGFycmllcnM/"
ctArr << "VGhpcyBtYW4gaGFkIGtlcHQgYSBzY2hvb2w="
ctArr << "QW5kIHJvZGUgb3VyIHdpbmdlZCBob3JzZS4="
ctArr << "VGhpcyBvdGhlciBoaXMgaGVscGVyIGFuZCBmcmllbmQ="
ctArr << "V2FzIGNvbWluZyBpbnRvIGhpcyBmb3JjZTs="
ctArr << "SGUgbWlnaHQgaGF2ZSB3b24gZmFtZSBpbiB0aGUgZW5kLA=="
ctArr << "U28gc2Vuc2l0aXZlIGhpcyBuYXR1cmUgc2VlbWVkLA=="
ctArr << "U28gZGFyaW5nIGFuZCBzd2VldCBoaXMgdGhvdWdodC4="
ctArr << "VGhpcyBvdGhlciBtYW4gSSBoYWQgZHJlYW1lZA=="
ctArr << "QSBkcnVua2VuLCB2YWluLWdsb3Jpb3VzIGxvdXQu"
ctArr << "SGUgaGFkIGRvbmUgbW9zdCBiaXR0ZXIgd3Jvbmc="
ctArr << "VG8gc29tZSB3aG8gYXJlIG5lYXIgbXkgaGVhcnQs"
ctArr << "WWV0IEkgbnVtYmVyIGhpbSBpbiB0aGUgc29uZzs="
ctArr << "SGUsIHRvbywgaGFzIHJlc2lnbmVkIGhpcyBwYXJ0"
ctArr << "SW4gdGhlIGNhc3VhbCBjb21lZHk7"
ctArr << "SGUsIHRvbywgaGFzIGJlZW4gY2hhbmdlZCBpbiBoaXMgdHVybiw="
ctArr << "VHJhbnNmb3JtZWQgdXR0ZXJseTo="
ctArr << "QSB0ZXJyaWJsZSBiZWF1dHkgaXMgYm9ybi4="

consistentKey = randomAESKey16
nonce = "\0"*8

ctArr = ctArr.map do |x|
	aesCTROperation(x.unpack("m").join, nonce, consistentKey)
end 



# Brute force method sucks, but it is nice as a proof of concept.
bruteForceCTR(ctArr, "I ", 0)
bruteForceCTR(ctArr, "Or ", 5)
bruteForceCTR(ctArr, "When ", 21)
bruteForceCTR(ctArr, "In the ", 36)
bruteForceCTR(ctArr, "Transform ", 38)
bruteForceCTR(ctArr, "To please ", 10)
bruteForceCTR(ctArr, "In the case ", 36)
bruteForceCTR(ctArr, "Transformed ", 38)

