# Configuration

Normally, a user needs to carefully adjust the `layer.conf` and `bblayers.conf` files in the 
build tree to select which functionalities to include and which not. Also, it might be necessary 
to fiddle with the custom recipes to reach the desired behavior. The idea here is that all 
functionality provided by the YoT layers can be configured on project root level, using one 
YAML configuration file (YAML for the sake of readability).

For bitbake to notice anything happened outside of it's (for a good reason) isolated environment, 
any variables set in the config file need to be set as environment variables (with `export MYVAR=val`) 
and then added to the `BB_EXTRA_WHITELIST` variable globally visible as soon as Yocto's 
`oe-env-init` script ran.

This is what happens in the `configure.sh` script:
- a file named `config.yml` is searched in the root of the repository, expected to have proper 
  YAML syntax (see `config-sample.yml` for reference)
- each item in the file is exported as environment variable according to the following schema:
  - for each level of hierarchy, take the left-hand side and add it capitalized and separated 
    by underscore to the env var's name
  - finally take the right-hand side as value of the env var
  - Example:
    ```yaml
    config:
      foo:
        bar:
          far_boo: "value"
    ```
    will be exported as `CONFIG_FOO_BAR_FAR_BOO=value`.


## Syntax

- The normal YAML syntax is applied
- Empty lines and comments (denoted by `#`) are ignored
- Values *must not contain whitespaces*. Anything that can be the right hand side of a shell variable 
  *without quotes* is allowed (escaping quotes to have them appear in the assignment is untested so far).
- Values can be "flat arrays", i.e. lists of values separated by some sort of delimiter.
  - This can be done on several levels, hence creating sort of multidimensional arrays
  - There is a parsing class for these flat arrays in `meta-common` - check out `flatarray.bbclass`


## Resources

- [Exporting environment variables to bitbake](https://stackoverflow.com/questions/17366984/is-it-possible-to-pass-in-command-line-variables-to-a-bitbake-build)
