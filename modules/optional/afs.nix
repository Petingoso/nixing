{...}: {
  services.openafsClient.enable = true;
  services.openafsClient.cellName = "ist.utl.pt";
  security.krb5.enable = true;
  security.krb5.settings.libdefaults.default_realm = "IST.UTL.PT";
}
