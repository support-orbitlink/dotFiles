local kitty = requires("kitty")

	config = kitty.config_builder()
	config = {
		automatically_reload_config = true,
	}
return config
