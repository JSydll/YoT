# -------------------
# Sets all parameters used to patch the configuration template file
# -------------------
def generate_config(datastore):
    static_ip = datastore.getVar("NET_STATIC_IP")
    has_static = (static_ip != None) and (len(static_ip) != 0)
    dns = datastore.getVar("NET_DNS_SERVER")
    params = { 
        "DNS_SERVER": (dns if dns != None else "8.8.8.8") 
    }

    if not has_static:
        params["DHCP_MODE"] = "yes"
        params["STATIC"] = "#"
    else:
        params["DHCP_MODE"] = "no"
        params["STATIC"] = ""
        params["STATIC_IP"] = static_ip
        params["GATEWAY_IP"] = '.'.join(static_ip.split('.')[0:3]) + '.1'

    return params