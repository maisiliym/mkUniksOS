{
  description = "mkUniksOS";

  outputs = { self }: {
    SobUyrld = {
      modz = [ "hyraizyn" "uyrldSet" ];
      lamdy = import ./lamdy.nix;
    };
  };
}
