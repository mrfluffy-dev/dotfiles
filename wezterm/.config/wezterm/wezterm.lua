local wezterm = require 'wezterm';

return {
  window_close_confirmation = 'NeverPrompt',
  -- option	= value	, [default] comment

  -- Fonts
  font     	= wezterm.font("JetBrains Mono")                             	, -- [JetBrains Mono]
  -- font  	= wezterm.font("JetBrains Mono", {weight="Bold",italic=true})	, -- [JetBrains Mono] Name with parameters
  font_size	= 12.0                                                       	, -- [12.0]

  -- Colors
  color_scheme     	= "Dracula (Official)"   	, -- full list @ wezfurlong.org/wezterm/colorschemes/index.html

  -- Appearance
  window_background_opacity   	= 0.9  	, -- [1.0] alpha channel value with floating point numbers in the range 0.0 (meaning completely translucent/transparent) through to 1.0 (meaning completely opaque)
  enable_tab_bar              	= false	, -- [true]
  hide_tab_bar_if_only_one_tab	= false	, -- [false] hide the tab bar when there is only a single tab in the window
}
