# -------------------
# Creates a WPA PSK key from an SSID and a password
# -------------------
def wpa_psk(ssid, password):
    import hashlib, binascii
    binkey = hashlib.pbkdf2_hmac(
                'sha1',
                str.encode(password),
                str.encode(ssid),
                4096,
                256
            )
    return (binascii.hexlify(binkey)[0:64].decode('utf8'))


# -------------------
# Sets all parameters used to patch the configuration template file
# -------------------
def generate_config(datastore):
    ssid = datastore.getVar("WIFI_SSID")
    pwd = datastore.getVar("WIFI_PWD")
    params = { 
        "WIFI_SSID": ssid,  
        "WIFI_PSK": wpa_psk(ssid, pwd)
        }
    return params