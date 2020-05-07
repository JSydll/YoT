# -------------------
# Sets all parameters used to patch the configuration template file
# -------------------
def generate_config(datastore):
    static_ipv4 = datastore.getVar("STATIC_IP_V4")
    has_ipv4 = (static_ipv4 == None) or bool(static_ipv4.length)
    static_ipv6 = datastore.getVar("STATIC_IP_V6")
    has_ipv6 = (static_ipv6 == None) or bool(static_ipv6.length)
    params = { "DNS_SERVER": datastore.getVar("DNS_SERVER") }

    if (not has_ipv4 and not has_ipv6):
        params["DHCP_MODE"] = "yes"
    elif (has_ipv4 and has_ipv6):
        params["DHCP_MODE"] = "no"
    elif (has_ipv4 and not has_ipv6):
        params["DHCP_MODE"] = "ipv6"
    else:
        params["DHCP_MODE"] = "ipv4"

    if (not has_ipv4):
        params["IP_V4"] = "#"
    else:
        params["IP_V4"] = ""
        params["STATIC_IP_V4"] = static_ipv4
        #params["GATEWAY_IP_V6"] = '.'.join(static_ipv4.split('.')[0:2])
    
    if (not has_ipv6):
        params["IP_V6"] = "#"
    else:
        params["IP_V6"] = ""
        params["STATIC_IP_V6"] = static_ipv6

    return params