# -------------------
# Methods to modify templated files
# -------------------

# -------------------
# Finds parameters in the given file and replaces them with the provided values
# 
# By default expects a %%PARAM_NAME%% syntax for the placeholders.
# 
# @param path to the file to be modufied
# @param params associative array of parameter name and the value to be set
# @param prepostfix unique character set used to prefix and postfix parameter 
# names in the template file.
# -------------------
def preplace_execute(path, params, prepostfix = "%%"):
    import fileinput
    import sys
    for line in fileinput.input(path, inplace=True):
        out = line
        for k, v in params.items():
            out = out.replace(prepostfix + k + prepostfix, str(v))
        sys.stdout.write(out)

EXPORT_FUNCTIONS execute