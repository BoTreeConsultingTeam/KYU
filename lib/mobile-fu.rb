 # Returns either true or false depending on whether or not the format of the
# request is either :mobile or not.
def in_mobile_view?
return false unless request.format
request.format.to_sym == :mobile
end 