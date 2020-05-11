# -------------------
# Helper functions to deal with array values in environment variables
# -------------------

# -------------------
# Parses a delimiter separated string into an array
# -------------------
def flatarray_parse(stringified, separator = ';'):
    if stringified == None:
        return []
    else:
        return stringified.split(separator)

EXPORT_FUNCTIONS parse