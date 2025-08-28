local user = {
	name = "Autumn",
	host = "BlackArch",
	user_img = os.getenv("HOME") .. "/.config/awesome/themes/custom/wallpapers/hayati.jpeg",

	terminal = "alacritty",
	file_manager = "thunar",
	browser = "firefox",
	editor = "nvim",
	music_player = "spotify",
	image_viewer = "feh",
	video_player = "mpv",

	wallpaper = "./wallpapers/hayati.jpeg",
	bar_floating = true,
	city = "new delhi",
	-- We are using the free weather api from rapidapi
	-- Get an api key from RapidApi and subscribe to:
	-- https://rapidapi.com/weatherapi/api/weatherapi-com
	rapid_api_key = "b0286087bfmshfa69e2cad96216ep15190cjsn57eb91b3cf1b",
}

return user
