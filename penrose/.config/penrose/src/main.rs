#[macro_use]
extern crate penrose;

use penrose::{
    contrib::{
        actions::{focus_or_spawn,update_monitors_via_xrandr},
        extensions::Scratchpad,
    },
    core::{
        config::Config,
        helpers::index_selectors,
        hooks::Hook,
        data_types::{Region,RelativePosition},
        layout::{side_stack, Layout, LayoutConf},
        manager::WindowManager,
        xconnection::XConn,
    },
    logging_error_handler, spawn,
    xcb::{XcbConnection, XcbHooks},
    Backward, Forward, Less, More, Result, Selector,
};

use simplelog::{LevelFilter, SimpleLogger};

// Replace these with your preferred terminal and program launcher
const TERMINAL: &str = "alacritty";
const LAUNCHER: &str = "rofi -no-lazy-greb -show drun -icon-theme 'Papirus' -show-icons";

struct StartupHook {}
impl<X: XConn> Hook<X> for StartupHook {
    fn startup(&mut self, wm: &mut WindowManager<X>) -> Result<()> {
        if wm.n_screens() == 1 {
            spawn!("polybar --reload barbase2")
        }
        else {
            spawn!("polybar --reload barbase1");
            spawn!("polybar --reload barbase2")
        };
        spawn!("xss-lock /home/$USER/.config/scripts/betterlockscreen.sh");
        spawn!("picom --backend glx");
        spawn!("nitrogen --restore")
    }
}


struct Monitors {}
impl<X> Hook<X> for Monitors
where
    X: XConn,
{
    fn randr_notify(&mut self, wm: &mut WindowManager<X>) -> Result<()> {
        update_monitors_via_xrandr("HDMI-A-0", "eDP", RelativePosition::Left);
        if wm.n_screens() != 1 {
            spawn!("polybar --reload barbase1")
        }
        else {
            spawn!("echo 'Only one screen connected'")
        }
    }
}




fn main() -> penrose::Result<()> {
    // Initialise the logger (use LevelFilter::Debug to enable debug logging)
    if let Err(e) = SimpleLogger::init(LevelFilter::Info, simplelog::Config::default()) {
        panic!("unable to set log level: {}", e);
    };

    let sp = Scratchpad::new(TERMINAL, 0.8, 0.8);

    let hooks: XcbHooks = vec![
        Box::new(StartupHook {}),
        Box::new(Monitors {}),
        sp.get_hook(),
    ];




    // Created at startup. See keybindings below for how to access them
    let mut config_builder = Config::default().builder();
    config_builder
        .workspaces(vec!["1", "2", "3", "4", "5", "6", "7", "8", "9"])
        // Windows with a matching WM_CLASS will always float
        .floating_classes(vec!["dmenu", "dunst", "polybar"])
        // Client border colors are set based on X focus
        .focused_border("#8218c4")?
        .unfocused_border("#1A1A1A")?
        .gap_px(0)
        .top_bar(true)
        .bar_height(32);

    // Default number of clients in the main layout area
    let n_main = 1;

    // Default percentage of the screen to fill with the main area of the layout
    let ratio = 0.5;

    config_builder.layouts(vec![Layout::new(
        "[side]",
        LayoutConf::default(),
        side_stack,
        n_main,
        ratio,
    )]);
    let config = config_builder.build().unwrap();
    let key_bindings = gen_keybindings! {
        // Program launchers
        "A-d" => run_external!(LAUNCHER);
        "A-Return" => run_external!(TERMINAL);

        // Exit Penrose (important to remember this one!)
        "A-S-q" => run_internal!(exit);

        // client management
        "A-j" => run_internal!(cycle_client, Forward);
        "A-k" => run_internal!(cycle_client, Backward);
        "A-S-j" => run_internal!(drag_client, Forward);
        "A-S-k" => run_internal!(drag_client, Backward);
        "A-S-f" => run_internal!(toggle_client_fullscreen, &Selector::Focused);
        "A-q" => run_internal!(kill_client);

        // workspace management
        "A-Tab" => run_internal!(toggle_workspace);
        "A-M-period" => run_internal!(cycle_workspace, Forward);
        "A-M-comma" => run_internal!(cycle_workspace, Backward);

        // move cursor between screens
        "A-l" => run_internal!(cycle_screen, Forward);
        "A-h" => run_internal!(cycle_screen, Backward);

        // Layout management
        "A-grave" => run_internal!(cycle_layout, Forward);
        "A-S-grave" => run_internal!(cycle_layout, Backward);
        "M-A-Up" => run_internal!(update_max_main, More);
        "M-A-Down" => run_internal!(update_max_main, Less);
        "A-S-h" => run_internal!(update_main_ratio, More);
        "A-S-l" => run_internal!(update_main_ratio, Less);


        "A-backslash" => sp.toggle();

        //print screen
        "A-p" => run_external!("flameshot gui");

        //controll audio
        "XF86AudioMute" => run_external!("pamixer -t");
        "XF86AudioLowerVolume" => run_external!("pamixer --allow-boost -d 5");
        "XF86AudioRaiseVolume" => run_external!("pamixer --allow-boost -i 5");
        "XF86AudioPlay" => run_external!("playerctl play-pause");
        "XF86AudioNext" => run_external!("playerctl next");
        "XF86AudioPrev" => run_external!("playerctl previous");
        "XF86AudioStop" => run_external!("playerctl stop");

        //my own keybindings
        "A-f" => run_external!("pcmanfm");
        "A-b" => focus_or_spawn("qutebrowser","qutebrowser");
        "M-l" => run_external!("betterlockscreen -l");


        map: { "1", "2", "3", "4", "5", "6", "7", "8", "9" } to index_selectors(9) => {
            "A-{}" => focus_workspace (REF);
            "A-S-{}" => client_to_workspace (REF);
        };
    };

    let conn = XcbConnection::new()?;

    let mut wm = WindowManager::new(config, conn, hooks, logging_error_handler());
    wm.init()?;
    wm.grab_keys_and_run(key_bindings, map! {})
}
