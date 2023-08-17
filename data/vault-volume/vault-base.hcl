ui = true

api_addr = "https://vault:8201"
storage "file" {
    path = "/opt/vault/data"
}

listener "tcp" {
    address = "0.0.0.0:8201"
    tls_cert_file = "/data/vault_server.crt"
    tls_key_file = "/data/vault_server.key"
}

