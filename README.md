# AdditionalMembers

The purpose of this package is to decode JSON data when you don't want to fully specify the
structure of the data. This can happen when you are using a peice fo the JSON data, but not
the full structure, or you the full structure of the JSON data is not defined. 

It is not necessary useful to do this in many cases, but a few examples are including caching
data so that you can take advantage of the additional fields at a later time without refetching
the original JSON, or rerouting data from on source to another when you only care about
some of the fields or need to restructure before sending it off.


